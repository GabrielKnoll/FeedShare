import {Episode, Podcast, Prisma} from '@prisma/client';
import PodcastIndexClient from 'podcastdx-client';
import prismaClient from './prismaClient';
import normalizeUrl from 'normalize-url';
import {htmlToText} from 'html-to-text';
import {decodeXML} from 'entities';
import {ParserResult} from '../queries/resolveShareUrl';
import env from './env';
import {iTunesPodcast} from './appleApi';
import {
  ApiResponse,
  PIApiEpisodeInfo,
  PIApiFeed,
} from 'podcastdx-client/dist/src/types';

export const podcastIndexClient = new PodcastIndexClient({
  key: env.PODCAST_INDEX_KEY,
  secret: env.PODCAST_INDEX_SECRET,
});

async function podcastFromFeeds(feeds: string[]) {
  const apiResponse = await Promise.all(
    feeds.map(async (feed) => {
      let res: ApiResponse.Podcast | undefined;
      try {
        res = await podcastIndexClient.podcastByUrl(feed);
      } catch (e) {
        console.error(e, feed);
      }
      if (res?.status === ApiResponse.Status.Success) {
        throw res;
      }
    }),
  )
    .then(() => undefined)
    .catch((result: ApiResponse.Podcast) => result);

  if (apiResponse) {
    return prismaClient.podcast.upsert({
      create: podcastFromApiResponse(apiResponse.feed),
      update: podcastFromApiResponse(apiResponse.feed),
      where: {
        id: String(apiResponse.feed.id),
      },
    });
  }
}

function podcastFromApiResponse(
  apiResponse: PIApiFeed,
): Prisma.PodcastCreateInput {
  return {
    id: String(apiResponse.id),
    title: apiResponse.title,
    itunesId: apiResponse.itunesId,
    publisher: apiResponse.author,
    artwork: apiResponse.image,
  };
}

export async function fetchPodcast({
  itunesId,
  feeds = [],
}: ParserResult): Promise<Podcast | undefined | null> {
  if (itunesId) {
    const podcast = await prismaClient.podcast.findFirst({
      where: {
        itunesId,
      },
    });

    if (podcast) {
      return podcast;
    }

    const itunesPodcast = await iTunesPodcast(itunesId);
    if (itunesPodcast) {
      feeds.push(itunesPodcast?.feedUrl);
    }
  }

  if (feeds.length > 0) {
    return podcastFromFeeds(feeds);
  }
}

function urlMatch(url1?: string, url2?: string): boolean {
  if (!url1 || !url2) {
    return false;
  }
  try {
    url1 = normalizeUrl(url1, {stripProtocol: true, stripHash: true});
    url2 = normalizeUrl(url2, {stripProtocol: true, stripHash: true});
  } catch (e) {
    return false;
  }
  return url1 === url2;
}

function titleMatch(title1?: string, title2?: string): boolean {
  if (!title1 || !title2) {
    return false;
  }
  return title2.includes(title1);
}

export async function fetchEpisode(
  podcastId: number,
  {enclosureUrl, episodeTitle, episodeUrl}: ParserResult,
): Promise<Episode | undefined> {
  const episodes = await fullEpisodeById(podcastId);
  if (episodes.status === ApiResponse.Status.Success) {
    const apiResponse = episodes.items.find((e) => {
      try {
        return (
          urlMatch(e.enclosureUrl, enclosureUrl) ||
          titleMatch(e.title, episodeTitle) ||
          urlMatch(e.link, episodeUrl)
        );
      } catch (e) {
        return false;
      }
    });

    if (apiResponse) {
      return prismaClient.episode.upsert({
        create: episodeFromApiResponse(apiResponse),
        update: episodeFromApiResponse(apiResponse),
        where: {
          id: String(apiResponse.id),
        },
      });
    }
  }
}

function episodeFromApiResponse(
  apiResponse: PIApiEpisodeInfo,
): Prisma.EpisodeCreateInput {
  return {
    id: String(apiResponse.id),
    datePublished: new Date(apiResponse.datePublished * 1000),
    artwork: apiResponse.image,
    title: decodeXML(apiResponse.title),
    durationSeconds:
      // @ts-ignore: Some episodes have hh:mm:ss format
      apiResponse.duration > 99 ? apiResponse.duration : undefined,
    url: apiResponse.link,
    enclosureLength: apiResponse.enclosureLength,
    enclosureUrl: apiResponse.enclosureUrl,
    enclosureType: apiResponse.enclosureType,
    description: apiResponse.description,
    podcast: {
      connect: {
        id: String(apiResponse.feedId),
      },
    },
  };
}

export async function latestEpisodes(
  podcast: Podcast,
  limit: number,
): Promise<Episode[] | null> {
  const res = await fullEpisodeById(parseInt(podcast.id, 10), {
    max: limit,
  });

  if (res.status === ApiResponse.Status.Success) {
    return Promise.all(
      res.items.map((apiResponse) =>
        prismaClient.episode.upsert({
          create: episodeFromApiResponse(apiResponse),
          update: episodeFromApiResponse(apiResponse),
          where: {
            id: String(apiResponse.id),
          },
        }),
      ),
    );
  }
  return null;
}

export async function findPodcast(
  query: string,
  limit: number = 10,
): Promise<Podcast[] | null> {
  const res = await podcastIndexClient.search(query);
  if (res.status === ApiResponse.Status.Success) {
    return Promise.all(
      res.feeds.slice(0, limit).map((feed) =>
        prismaClient.podcast.upsert({
          create: podcastFromApiResponse(feed),
          update: podcastFromApiResponse(feed),
          where: {
            id: String(feed.id),
          },
        }),
      ),
    );
  }
  return null;
}

export const fullPodcastById: typeof podcastIndexClient.podcastById = async (
  id,
) => {
  podcastIndexClient.podcastById;
  const result = await podcastIndexClient['fetch']('/podcasts/byfeedid', {
    id,
    fulltext: true,
  });
  if (!result.feed.categories) {
    result.feed.categories = {};
  }
  return result;
};

const fullEpisodeById: typeof podcastIndexClient.episodesByFeedId = (
  id,
  options,
) =>
  podcastIndexClient['fetch']('/episodes/byfeedid', {
    ...options,
    id,
    fulltext: true,
  });
