import {Episode, Prisma, Podcast} from '@prisma/client';
import PodcastIndexClient from 'podcastdx-client';
import {ApiResponse} from 'podcastdx-client/dist/types';
import env from './env';
import prismaClient from './prismaClient';
import normalizeUrl from 'normalize-url';
import {htmlToText} from 'html-to-text';
import {decodeXML} from 'entities';

const podcastIndexClient = new PodcastIndexClient({
  key: env.PODCAST_INDEX_KEY,
  secret: env.PODCAST_INDEX_SECRET,
});

async function podcastFromFeeds(feeds: string[]) {
  const cached = await prismaClient.podcast.findFirst({
    where: {
      feed: {
        in: feeds,
      },
    },
  });

  if (cached) {
    return cached;
  }

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
    return await prismaClient.podcast.create({
      data: podcastFromApiResponse(apiResponse.feed),
    });
  }
}

async function podcastFromItunesId(itunesId: number) {
  const cached = await prismaClient.podcast.findUnique({
    where: {
      itunesId,
    },
  });
  if (cached) {
    return cached;
  }

  const apiResponse = await podcastIndexClient.podcastByItunesId(itunesId);
  if (apiResponse?.status === ApiResponse.Status.Success) {
    return await prismaClient.podcast.create({
      data: podcastFromApiResponse(apiResponse.feed),
    });
  }
}

function podcastFromApiResponse(
  apiResponse: ApiResponse.PodcastFeed,
): Prisma.PodcastCreateInput {
  return {
    id: String(apiResponse.id),
    feed: apiResponse.url,
    title: apiResponse.title,
    itunesId: apiResponse.itunesId,
    description: apiResponse.description,
    publisher: apiResponse.author,
    artwork: apiResponse.image,
    url: apiResponse.link,
    apiResponse: apiResponse as any,
  };
}

export async function fetchPodcast(
  itunesId: number | undefined,
  feeds: string[] | undefined,
): Promise<Podcast | undefined> {
  return itunesId
    ? await podcastFromItunesId(itunesId)
    : await podcastFromFeeds(feeds!);
}

function urlMatch(url1?: string, url2?: string): boolean {
  if (!url1 || !url2) {
    return false;
  }
  try {
    url1 = normalizeUrl(url1, {stripProtocol: true});
    url2 = normalizeUrl(url2, {stripProtocol: true});
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
  enclosureUrl: string | undefined,
  title: string | undefined,
  link: string | undefined,
): Promise<Episode | undefined> {
  const episodes = await podcastIndexClient.episodesByFeedId(podcastId);
  if (episodes.status === ApiResponse.Status.Success) {
    const apiResponse = episodes.items.find((e) => {
      try {
        return (
          urlMatch(e.enclosureUrl, enclosureUrl) ||
          titleMatch(e.title, title) ||
          urlMatch(e.link, link)
        );
      } catch (e) {
        return false;
      }
    });

    if (apiResponse) {
      return await prismaClient.episode.upsert({
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
  apiResponse: ApiResponse.EpisodeInfo,
): Prisma.EpisodeCreateInput {
  return {
    id: String(apiResponse.id),
    enclosureUrl: apiResponse.enclosureUrl,
    enclosureType: apiResponse.enclosureType,
    enclosureLength: apiResponse.enclosureLength || undefined,
    description: htmlToText(apiResponse.description, {
      tags: {
        a: {options: {ignoreHref: true}},
        ul: {options: {itemPrefix: '• '}},
      },
    }).trim(),
    datePublished: new Date(apiResponse.datePublished * 1000),
    artwork: apiResponse.image,
    title: decodeXML(apiResponse.title),
    durationSeconds:
      // @ts-ignore: Some episodes have hh:mm:ss format
      apiResponse.duration > 99 ? apiResponse.duration : undefined,
    url: apiResponse.link,
    apiResponse: apiResponse as any,
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
  const res = await podcastIndexClient.episodesByFeedId(
    parseInt(podcast.id, 10),
    {
      max: limit,
    },
  );

  if (res.status === ApiResponse.Status.Success) {
    return await Promise.all(
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
    return await Promise.all(
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
