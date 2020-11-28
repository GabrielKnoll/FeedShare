import {Episode, EpisodeCreateInput, Podcast} from '@prisma/client';
import PodcastIndexClient from 'podcastdx-client';
import {ApiResponse} from 'podcastdx-client/dist/types';
import env from './env';
import prismaClient from './prismaClient';

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
        console.error(e);
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

export async function fetchEpisode(
  podcastId: number,
  enclosureUrl: string | undefined,
  title: string | undefined,
): Promise<Episode | undefined> {
  const cached = await prismaClient.episode.findFirst({
    where: {
      podcast: {
        id: podcastId,
      },
      enclosureUrl,
      title,
    },
  });

  if (cached) {
    return cached;
  }

  const episodes = await podcastIndexClient.episodesByFeedId(podcastId);
  if (episodes.status === ApiResponse.Status.Success) {
    const apiResponse = episodes.items.find((e) => false);

    if (apiResponse) {
      return await prismaClient.episode.create({
        data: episodeFromApiResponse(apiResponse),
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
    // durationSeconds: 0,
    url: apiResponse.link,
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
