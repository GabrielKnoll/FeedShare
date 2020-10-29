import queryString from 'query-string';
import {ampPodcast, ampEpisode} from './appleApi';
import prismaClient from './prismaClient';
import {PodcastCreateInput, EpisodeCreateInput} from '@prisma/client';
import URL from 'url';
import fetch from 'node-fetch';
import cheerio from 'cheerio';

const CACHE_DURATION = 24 * 60 * 60 * 1000;

async function fetchPage(url: URL.UrlWithStringQuery) {
  const pageContent = await fetch(url).then((res) => res.text());
  return cheerio.load(pageContent);
}

function idFromAppleUrl(itunesUrl?: string): string | undefined {
  if (itunesUrl && URL.parse(itunesUrl).hostname === 'podcasts.apple.com') {
    const match = itunesUrl.match(/id(\d+)/) ?? [];
    return match[1];
  }
}

export default async function (shareUrl: string) {
  const url = URL.parse(shareUrl);
  let applePodcastId: string | undefined = undefined;
  let appleEpisodeId: string | undefined = undefined;
  let rssFeed: string | undefined = undefined;

  switch (url.hostname) {
    case 'podcasts.apple.com': {
      // https://podcasts.apple.com/de/podcast/pakistan/id409553739?i=1000477131403&l=en?l=en&i=1000477131403
      let [country, podcast, episode, podcastID] = (url.pathname ?? '')
        .split('/')
        .filter(Boolean);
      applePodcastId = podcastID.replace(/^id/, '');
      let {i: id} = queryString.parse(url.search ?? '');
      appleEpisodeId = (Array.isArray(id) ? id[0] : id) ?? undefined;
      break;
    }

    case 'castro.fm': {
      // https://castro.fm/podcast/fc60896e-f790-4357-98a8-b8901270a0f8
      let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

      if (type === 'itunes') {
        // https://castro.fm/itunes/1172218725
        applePodcastId = id;
        break;
      }

      const $ = await fetchPage(url);
      const overcastLink = $(
        '#co-supertop-castro-open-in a[href^="https://overcast.fm/itunes"]',
      );
      if (overcastLink.length > 0) {
        const podcastId =
          overcastLink
            .first()
            .attr('href')
            ?.match(/https:\/\/overcast\.fm\/itunes(\d+)/) ?? [];
        applePodcastId = podcastId[1];
      }

      rssFeed = $('img[alt="Subscribe to RSS"]').parent().attr('href');

      if (type === 'episode') {
        // https://castro.fm/episode/XjciiV
      }
      break;
    }

    case 'overcast.fm': {
      // https://overcast.fm/+HiEYDNrZs
      // https://overcast.fm/itunes1357986673
      // https://overcast.fm/itunes1357986673/tony-basilios-next-level-network-family-of-podcasts
      let [itunes] = (url.pathname ?? '').split('/').filter(Boolean);
      const podcastId = itunes.match(/^itunes(\d+)$/) ?? [];
      applePodcastId = podcastId[1];

      if (!applePodcastId) {
        const $ = await fetchPage(url);
        applePodcastId = idFromAppleUrl(
          $('.externalbadges a[href^="https://podcasts.apple.com/podcast/"]')
            .first()
            .attr('href'),
        );
        rssFeed = $('img[src="/img/badge-rss.svg"]').parent().attr('href');
      }
      break;
    }

    case 'pca.st': {
      // https://pca.st/itunes/1172218725
      let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);
      if (type === 'itunes') {
        applePodcastId = id;
      } else {
        // https://pca.st/63et
        const $ = await fetchPage(url);
        rssFeed = $('.rss_button a').first().attr('href');
        applePodcastId = idFromAppleUrl(
          $('.itunes_button a').first().attr('href'),
        );
      }
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
