import fetch from 'node-fetch';
import {Parser} from 'prettier';
import {ParserResult} from './resolveShareUrl';

let AMP_TOKEN: string | null = null;

async function ampApiRequest<T>(
  url: string,
  retries: number = 3,
): Promise<{
  data: T[];
  next?: string;
}> {
  url = 'https://amp-api.podcasts.apple.com/v1/catalog/us' + url;
  const token = await ampApiToken();
  const response = await fetch(url, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  if (response.status === 401) {
    AMP_TOKEN = null;
    if (retries > 0) {
      return ampApiRequest<T>(url, retries - 1);
    }
  }
  return response.json();
}

export async function ampPodcast({applePodcastId}: ParserResult) {
  if (!applePodcastId) {
    return;
  }
  const result = await ampApiRequest<AppleApi.AmpPodcast>(
    `/podcasts/${applePodcastId}`,
  );
  return result?.data?.shift();
}

export async function ampEpisode(parserResult: ParserResult) {
  if (parserResult.type !== 'Episode' || !parserResult.applePodcastId) {
    return;
  }

  if (parserResult.appleEpisodeId) {
    const result = await ampApiRequest<AppleApi.AmpEpisode>(
      `/podcast-episodes/${parserResult.appleEpisodeId}`,
    );
    return result?.data?.find(
      (episode) => episode.id === parserResult.appleEpisodeId,
    );
  } else if (parserResult.episodeUrl) {
    const result = await ampApiRequest<AppleApi.AmpEpisode>(
      `/podcasts/${parserResult.applePodcastId}/episodes?limit=50`,
    );
    return result?.data?.find(
      (episode) => episode.attributes.websiteUrl === parserResult.episodeUrl,
    );
  } else if (parserResult.episodeTitle) {
    const result = await ampApiRequest<AppleApi.AmpEpisode>(
      `/podcasts/${parserResult.applePodcastId}/episodes?limit=50`,
    );
    return result?.data?.find(
      (episode) => episode.attributes.name === parserResult.episodeTitle,
    );
  }
}

async function ampApiToken(): Promise<string | null> {
  if (AMP_TOKEN) {
    return AMP_TOKEN;
  }
  const res = await fetch(
    `https://podcasts.apple.com/us/podcast/luftpost-podcast/id409553739`,
  );
  if (!res.ok) {
    return null;
  }
  const html = await res.text();
  const match = html.match(
    /name="web-experience-app\/config\/environment" content="(.*)"/,
  );

  if (!match || match.length < 1) {
    return null;
  }

  const uri = decodeURIComponent(match[1]);
  const data: {
    MEDIA_API: {
      keyId: string;
      ttl: number;
      token: string;
    };
  } = JSON.parse(uri);

  return data.MEDIA_API.token;
}
