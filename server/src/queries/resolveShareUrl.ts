import {extendType, stringArg, objectType, nonNull} from 'nexus';
import requireAuthorization from '../utils/requireAuthorization';
import URL from 'url';
import fetch from 'node-fetch';
import cheerio from 'cheerio';
import apple from '../parser/apple';
import castro from '../parser/castro';
import overcast from '../parser/overcast';
import pocketcasts from '../parser/pocketcasts';
import generic from '../parser/generic';
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
          });
          t.field('podcast', {
            type: 'Podcast',
          });
        },
      }),
      args: {
        url: nonNull(stringArg()),
      },
      ...requireAuthorization,
      resolve: async (_root, {url}) => {
        const parsedUrl = URL.parse(url);
        const parser = PARSER[parsedUrl.hostname ?? ''] ?? generic;
        const parserResult = await parser(parsedUrl);

        const podcast = await fetchPodcast(parserResult);

        if (!podcast) {
          return {};
        }
        const episode = await fetchEpisode(
          parseInt(podcast.id, 10),
          parserResult,
        );

        return {
          episode,
          podcast,
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
  episodeUrl?: string;
  episodeTitle?: string;
  enclosureUrl?: string;
};

export type Parser = (url: URL.UrlWithStringQuery) => Promise<ParserResult>;

const PARSER: Record<string, Parser> = {
  'podcasts.apple.com': apple,
  'castro.fm': castro,
  'overcast.fm': overcast,
  'pca.st': pocketcasts,
};
