import {extendType, stringArg, objectType} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';
import {ampPodcast, ampEpisode, episodePayload} from '../utils/appleApi';
import prismaClient from '../utils/prismaClient';
import {
  PodcastCreateInput,
  EpisodeCreateInput,
  Episode,
  Podcast,
} from '@prisma/client';
import URL from 'url';
import fetch from 'node-fetch';
import cheerio from 'cheerio';
import apple from '../utils/parser/apple';
import castro from '../utils/parser/castro';
import overcast from '../utils/parser/overcast';
import pocketcasts from '../utils/parser/pocketcasts';
import spotify from '../utils/parser/spotify';
import {spotifyPodcastAndEpisode} from '../utils/spotifyApi';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('resolveShareUrl', {
      type: objectType({
        name: 'ResolvedShareUrl',
        definition(t) {
          t.field('episode', {
            type: 'Episode',
            nullable: true,
          });
          t.field('podcast', {
            type: 'Podcast',
            nullable: true,
          });
        },
      }),
      args: {
        url: stringArg({
          required: true,
        }),
      },
      ...requireAuthorization,
      resolve: async (_root, {url}) => {
        const {episode, podcast} = await resolve(url);
        return {
          episode,
          podcast: podcast,
        };
      },
    });
  },
});

const CACHE_DURATION = 24 * 60 * 60 * 1000;

export async function fetchPage(url: URL.UrlWithStringQuery) {
  const pageContent = await fetch(url).then((res) => res.text());
  return cheerio.load(pageContent);
}

type ParserResultType = 'Podcast' | 'Episode';

interface BaseParserResult {
  type: ParserResultType;
  applePodcastId?: string;
}

interface ParserResultPodcast extends BaseParserResult {
  type: 'Podcast';
  spotifyPodcastId?: string;
}

interface ParserResultEpisode extends BaseParserResult {
  type: 'Episode';
  episodeUrl?: string;
  episodeTitle?: string;
  appleEpisodeId?: string;
  spotifyEpisodeId?: string;
}

export type ParserResult = ParserResultPodcast | ParserResultEpisode;

const PARSER: Record<
  string,
  (url: URL.UrlWithStringQuery) => Promise<ParserResult>
> = {
  'podcasts.apple.com': apple,
  'castro.fm': castro,
  'overcast.fm': overcast,
  'pca.st': pocketcasts,
  'open.spotify.com': spotify,
};

type Field = 'ampId' | 'spotifyId';
async function fetchFromCache(
  type: 'Podcast',
  field: Field,
  value?: string,
): Promise<Podcast | null>;
async function fetchFromCache(
  type: 'Episode',
  field: Field,
  value?: string,
): Promise<Episode | null>;
async function fetchFromCache(
  type: ParserResultType,
  field: Field,
  value?: string,
) {
  if (!value) {
    return null;
  }
  const findFirst = {
    where: {
      AND: {
        [field]: value,
        updatedAt: {
          gt: new Date(new Date().getTime() - CACHE_DURATION),
        },
      },
    },
  };
  if (type === 'Podcast') {
    return prismaClient.podcast.findFirst(findFirst);
  } else {
    return prismaClient.episode.findFirst(findFirst);
  }
}

async function resolve(
  shareUrl: string,
): Promise<{
  podcast?: Podcast;
  episode?: Episode;
}> {
  const url = URL.parse(shareUrl);
  const parser = url.hostname ? PARSER[url.hostname] : undefined;

  if (!parser) {
    throw new Error(`Unknown share URL: ${shareUrl}`);
  }

  const parserResult = await parser(url);

  let [
    applePodcast,
    spotifyPodcast,
    appleEpisode,
    spotifyEpisode,
  ] = await Promise.all([
    fetchFromCache('Podcast' as const, 'ampId', parserResult.applePodcastId),
    fetchFromCache(
      'Podcast' as const,
      'spotifyId',
      parserResult.type === 'Podcast'
        ? parserResult.spotifyPodcastId
        : undefined,
    ),
    fetchFromCache(
      'Episode' as const,
      'ampId',
      parserResult.type === 'Episode' ? parserResult.appleEpisodeId : undefined,
    ),
    fetchFromCache(
      'Episode' as const,
      'spotifyId',
      parserResult.type === 'Episode'
        ? parserResult.spotifyEpisodeId
        : undefined,
    ),
  ]);

  // everything cached?
  if (
    parserResult.type === 'Episode' &&
    (appleEpisode || spotifyEpisode) &&
    (applePodcast || spotifyPodcast)
  ) {
    return {
      episode: appleEpisode ?? spotifyEpisode!,
      podcast: applePodcast ?? spotifyPodcast!,
    };
  } else if (
    parserResult.type === 'Podcast' &&
    (applePodcast || spotifyPodcast)
  ) {
    return {
      podcast: applePodcast ?? spotifyPodcast!,
    };
  }

  // need to fetch
  const [
    _ampPodcast,
    _ampEpisode,
    [_spotifyPodcast, _spotifyEpisode],
    feed,
  ] = await Promise.all([
    ampPodcast(parserResult),
    ampEpisode(parserResult),
    spotifyPodcastAndEpisode(parserResult),
    Promise.resolve('TODO'),
  ]);

  if (!_ampPodcast && !_spotifyPodcast) {
    throw new Error('Could not find Podcast');
  }

  const podcastData: PodcastCreateInput = _ampPodcast
    ? {
        ampApiResponse: _ampPodcast,
        title: _ampPodcast.attributes.name,
        url: _ampPodcast.attributes.websiteUrl,
        feed,
        publisher: _ampPodcast.attributes.artistName,
        description: _ampPodcast.attributes.description.standard,
        ampId: _ampPodcast.id,
        artwork: _ampPodcast.attributes.artwork.url,
      }
    : {
        spotifyApiResponse: _spotifyPodcast!,
        title: _spotifyPodcast!.name,
        feed,
        publisher: _spotifyPodcast!.publisher,
        description: _spotifyPodcast!.description,
        spotifyId: _spotifyPodcast!.id,
        artwork: _spotifyPodcast!.images.pop()?.url,
      };

  const podcast = await prismaClient.podcast.upsert({
    update: podcastData,
    create: podcastData,
    where: _ampPodcast
      ? {
          ampId: _ampPodcast.id,
        }
      : {
          spotifyId: _spotifyPodcast!.id,
        },
  });

  if (parserResult.type === 'Podcast' || (!_ampEpisode && !_spotifyEpisode)) {
    return {podcast};
  }

  const episodeData: EpisodeCreateInput = _ampEpisode
    ? episodePayload(_ampEpisode, podcast.ampId!)
    : {
        podcast: {
          connect: {
            id: podcast.id,
          },
        },
        title: _spotifyEpisode!.name,
        durationSeconds: Math.round(_spotifyEpisode!.duration_ms / 1000),
        description: _spotifyEpisode!.description,
        artwork: _spotifyEpisode!.images.pop()?.url,
        spotifyId: _spotifyEpisode!.id,
        spotifyApiResponse: _spotifyEpisode,
      };

  const episode = await prismaClient.episode.upsert({
    update: episodeData,
    create: episodeData,
    where: _ampEpisode
      ? {
          ampId: _ampEpisode.id,
        }
      : {
          spotifyId: _spotifyEpisode!.id,
        },
  });

  return {podcast, episode};
}
