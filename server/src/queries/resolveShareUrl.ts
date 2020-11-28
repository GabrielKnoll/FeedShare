import {extendType, stringArg, objectType} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';
import {Episode, Podcast} from '@prisma/client';
import URL from 'url';
import fetch from 'node-fetch';
import cheerio from 'cheerio';
import apple from '../utils/parser/apple';
import castro from '../utils/parser/castro';
import overcast from '../utils/parser/overcast';
import pocketcasts from '../utils/parser/pocketcasts';
import generic from '../utils/parser/generic';
import {fetchEpisode, fetchPodcast} from '../utils/podcastIndex';

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

export async function fetchPage(url: URL.UrlWithStringQuery) {
  const pageContent = await fetch(url).then((res) => res.text());
  return cheerio.load(pageContent);
}

export type ParserResult = {
  itunesId?: number;
  feeds?: string[];
  episodeTitle?: string;
  enclosureUrl?: string;
};

const PARSER: Record<
  string,
  (url: URL.UrlWithStringQuery) => Promise<ParserResult>
> = {
  'podcasts.apple.com': apple,
  'castro.fm': castro,
  'overcast.fm': overcast,
  'pca.st': pocketcasts,
};

async function resolve(
  shareUrl: string,
): Promise<{
  podcast?: Podcast;
  episode?: Episode;
}> {
  const url = URL.parse(shareUrl);
  const parser = PARSER[url.hostname ?? ''] ?? generic;
  const parserResult = await parser(url);

  const podcast = await fetchPodcast(parserResult.itunesId, parserResult.feeds);
  if (!podcast) {
    return {};
  }

  let episode: Episode | undefined;
  if (parserResult.enclosureUrl || parserResult.episodeTitle) {
    episode = await fetchEpisode(
      podcast.id,
      parserResult.enclosureUrl,
      parserResult.episodeTitle,
    );
  }

  return {podcast, episode};
}
