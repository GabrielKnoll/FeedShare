import {extendType, stringArg, objectType, nonNull} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';
import {Episode} from '@prisma/client';
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
      resolve: async (_root, {url}, {prismaClient}) => {
        const parsedUrl = URL.parse(url);
        const parser = PARSER[parsedUrl.hostname ?? ''] ?? generic;
        const parserResult = await parser(parsedUrl);

        const podcast = await fetchPodcast(
          parserResult.itunesId,
          parserResult.feeds,
        );

        if (!podcast) {
          return {};
        }
        const episode = await fetchEpisode(
          parseInt(podcast.id, 10),
          parserResult.enclosureUrl,
          parserResult.episodeTitle,
          url,
        );

        // log resolve
        const payload = {
          url,
          episode: episode
            ? {
                connect: {
                  id: episode.id,
                },
              }
            : undefined,
          podcast: {
            connect: {
              id: podcast.id,
            },
          },
        };
        await prismaClient.urlResolve.upsert({
          create: payload,
          update: payload,
          where: {
            url,
          },
        });

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

const PARSER: Record<
  string,
  (url: URL.UrlWithStringQuery) => Promise<ParserResult>
> = {
  'podcasts.apple.com': apple,
  'castro.fm': castro,
  'overcast.fm': overcast,
  'pca.st': pocketcasts,
};
