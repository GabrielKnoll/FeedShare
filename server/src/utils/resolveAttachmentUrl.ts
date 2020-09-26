import queryString from 'query-string';
import {ampPodcast, ampEpisode} from './appleApi';
import prismaClient from './prismaClient';
import {PodcastCreateInput, EpisodeCreateInput} from '@prisma/client';

const CACHE_DURATION = 24 * 60 * 60 * 1000;

export default async function (shareUrl: string) {
  const url = new URL(shareUrl);
  let applePodcastId: string | null = null;
  let appleEpisodeId: string | null = null;

  switch (url.hostname) {
    case 'podcasts.apple.com': {
      // https://podcasts.apple.com/de/podcast/pakistan/id409553739?i=1000477131403&l=en?l=en&i=1000477131403
      let [country, podcast, episode, podcastID] = url.pathname
        .split('/')
        .filter(Boolean);
      applePodcastId = podcastID.replace(/^id/, '');
      let {i: id} = queryString.parse(url.search);
      appleEpisodeId = Array.isArray(id) ? id[0] : id;
      break;
    }
    default: {
      throw new Error(`Unknown share URL: ${url}`);
    }
  }

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
    feed: 'todo',
    publisher: ampApiPodcast.attributes.artistName,
    description: ampApiPodcast.attributes.description.standard,
    ampId: applePodcastId,
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
