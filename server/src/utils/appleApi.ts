import fetch from 'node-fetch';

let AMP_TOKEN: string | null = null;

async function ampApiRequest<T>(
  url: string,
  retries: number = 3,
): Promise<{
  data: T[];
  next?: string;
}> {
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

export async function ampPodcast(id?: string) {
  if (!id) {
    return;
  }
  const result = await ampApiRequest<AppleApi.AmpPodcast>(
    `https://amp-api.podcasts.apple.com/v1/catalog/us/podcasts/${id}`,
  );
  if (result?.data?.length > 0) {
    return result.data[0];
  }
}

export async function ampEpisode(id?: string) {
  if (!id) {
    return;
  }
  const result = await ampApiRequest<AppleApi.AmpEpisode>(
    `https://amp-api.podcasts.apple.com/v1/catalog/us/podcast-episodes/${id}`,
  );
  return result?.data?.find((episode) => episode.id === id);
}

export async function ampEpisodeForUrl(podcastId: string, url: string) {
  const result = await ampApiRequest<AppleApi.AmpEpisode>(
    `https://amp-api.podcasts.apple.com/v1/catalog/us/podcasts/${podcastId}/episodes?limit=50`,
  );
  result?.data?.find((episode) => episode.attributes.websiteUrl === url);
}

export async function ampEpisodeForTitle(podcastId: string, title: string) {
  const result = await ampApiRequest<AppleApi.AmpEpisode>(
    `https://amp-api.podcasts.apple.com/v1/catalog/us/podcasts/${podcastId}/episodes?limit=50`,
  );
  result?.data?.find((episode) => episode.attributes.name === title);
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
