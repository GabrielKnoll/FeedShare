import {ampPodcast, ampEpisode} from './appleApi';
import prismaClient from './prismaClient';
import {
  PodcastCreateInput,
  EpisodeCreateInput,
  Episode,
  Podcast,
} from '@prisma/client';
import URL from 'url';
import fetch from 'node-fetch';
import cheerio from 'cheerio';
import apple from './parser/apple';
import castro from './parser/castro';
import overcast from './parser/overcast';
import pocketcasts from './parser/pocketcasts';
import spotify from './parser/spotify';
import {NexusGenEnums} from 'nexus-typegen';

const CACHE_DURATION = 24 * 60 * 60 * 1000;

export async function fetchPage(url: URL.UrlWithStringQuery) {
  const pageContent = await fetch(url).then((res) => res.text());
  return cheerio.load(pageContent);
}

interface BaseParserResult {
  applePodcastId?: string;
  rssFeed?: string;
  type: NexusGenEnums['AttachmentType'];
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

async function fetchFromCache<T extends NexusGenEnums['AttachmentType']>(
  type: T,
  field: 'ampId' | 'spotifyId',
  value: string,
): Promise<(T extends 'Podcast' ? Podcast : Episode) | null> {
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

export default async function (shareUrl: string) {
  const url = URL.parse(shareUrl);

  const parser = url.hostname ? PARSER[url.hostname] : undefined;
  if (!parser) {
    throw new Error(`Unknown share URL: ${url}`);
  }

  let parserResult = await parser(url);

  const LOOKUP_RESOLVER = {
    appleEpisodeId: () => {},
    spotifyEpisodeId: () => {},
    spotifyPodcastId: () => {},
    applePodcastId: () => {},
  };

  // cached values
  if (appleEpisodeId) {
    const episode = await prismaClient.episode.findOne({
      where: {ampId: appleEpisodeId},
    });

    if (
      episode &&
      episode.updatedAt.getTime() > new Date().getTime() - CACHE_DURATION
    ) {
      return episode;
    }
  }

  if (applePodcastId && !appleEpisodeId) {
    const podcast = await prismaClient.podcast.findOne({
      where: {ampId: applePodcastId},
    });

    if (
      podcast &&
      podcast.updatedAt.getTime() > new Date().getTime() - CACHE_DURATION
    ) {
      return podcast;
    }
  }

  const [ampApiPodcast, ampApiEpisode] = await Promise.all([
    ampPodcast(applePodcastId),
    ampEpisode(appleEpisodeId),
  ]);
  if (!ampApiPodcast) {
    return;
  }
  const podcastData: PodcastCreateInput = {
    ampApiResponse: ampApiPodcast,
    title: ampApiPodcast.attributes.name,
    url: ampApiPodcast.attributes.websiteUrl,
    feed: rssFeed ?? '',
    publisher: ampApiPodcast.attributes.artistName,
    description: ampApiPodcast.attributes.description.standard,
    ampId: applePodcastId,
    artwork: ampApiPodcast.attributes.artwork.url,
  };
  const podcast = await prismaClient.podcast.upsert({
    update: podcastData,
    create: podcastData,
    where: {
      ampId: applePodcastId,
    },
  });

  if (!ampApiEpisode) {
    return podcast;
  }
  const episodeData: EpisodeCreateInput = {
    podcast: {
      connect: {
        ampId: applePodcastId,
      },
    },
    title: ampApiEpisode.attributes.name,
    durationSeconds: ampApiEpisode.attributes.durationInMilliseconds / 1000,
    description: ampApiEpisode.attributes.description.standard,
    url: ampApiEpisode.attributes.websiteUrl,
    ampApiResponse: ampApiEpisode,
    ampId: appleEpisodeId,
    artwork: ampApiEpisode.attributes.artwork.url,
  };

  const episode = await prismaClient.episode.upsert({
    update: episodeData,
    create: episodeData,
    where: {
      ampId: appleEpisodeId,
    },
  });

  return episode;
}
