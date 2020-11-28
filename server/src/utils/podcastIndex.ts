import {Episode, EpisodeCreateInput, Podcast} from '@prisma/client';
import PodcastIndexClient from 'podcastdx-client';
import {ApiResponse} from 'podcastdx-client/dist/types';
import env from './env';
import prismaClient from './prismaClient';
import normalizeUrl from 'normalize-url';

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
    return await podcastFromApiResponse(apiResponse);
  }
}

async function podcastFromItunesId(itunesId: number) {
  const cached = await prismaClient.podcast.findOne({
    where: {
      itunesId,
    },
  });
  if (cached) {
    return cached;
  }

  const apiResponse = await podcastIndexClient.podcastByItunesId(itunesId);
  if (apiResponse?.status === ApiResponse.Status.Success) {
    return await podcastFromApiResponse(apiResponse);
  }
}

async function podcastFromApiResponse(apiResponse: ApiResponse.Podcast) {
  return await prismaClient.podcast.create({
    data: {
      id: apiResponse.feed.id,
      feed: apiResponse.feed.url,
      title: apiResponse.feed.title,
      itunesId: apiResponse.feed.itunesId,
      description: apiResponse.description,
      publisher: apiResponse.feed.author,
      artwork: apiResponse.feed.image,
      url: apiResponse.feed.link,
      apiResponse: apiResponse as any,
    },
  });
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
          id: apiResponse.id,
        },
      });
    }
  }
}

function episodeFromApiResponse(
  apiResponse: ApiResponse.EpisodeInfo,
): EpisodeCreateInput {
  return {
    id: apiResponse.id,
    enclosureUrl: apiResponse.enclosureUrl,
    enclosureType: apiResponse.enclosureType,
    enclosureLength: apiResponse.enclosureLength,
    description: apiResponse.description,
    datePublished: new Date(apiResponse.datePublished * 1000),
    artwork: apiResponse.image,
    title: apiResponse.title,
    // @ts-ignore
    durationSeconds: apiResponse.duration || undefined,
    url: apiResponse.link,
    apiResponse: apiResponse as any,
    podcast: {
      connect: {
        id: apiResponse.feedId,
      },
    },
  };
}

export async function latestEpisodes(
  podcast: Podcast,
  limit: number,
): Promise<Episode[] | null> {
  const res = await podcastIndexClient.episodesByFeedId(podcast.id, {
    max: limit,
  });

  if (res.status === ApiResponse.Status.Success) {
    return await Promise.all(
      res.items.map((apiResponse) =>
        prismaClient.episode.upsert({
          create: episodeFromApiResponse(apiResponse),
          update: episodeFromApiResponse(apiResponse),
          where: {
            id: apiResponse.id,
          },
        }),
      ),
    );
  }
  return null;
}
