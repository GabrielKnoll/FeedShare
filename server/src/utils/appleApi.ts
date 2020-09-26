import fetch from 'node-fetch';

let AMP_TOKEN: string | null = null;

type AmpPodcast = {
  id: string; // '409553739'
  type: 'podcasts';
  href: string; // '/v1/catalog/us/podcasts/409553739'
  attributes: {
    artwork: {
      width: number; // 1400;
      height: number;
      url: string; // 'https://is4-ssl.mzstatic.com/image/thumb/Podcasts113/v4/84/6e/74/846e740e-cb85-744e-8b5e-d8dc9a4b2c60/mza_7550981096815785933.png/{w}x{h}bb.{f}';
      bgColor: string; // 'b1dced';
      textColor1: string; // '08253c';
      textColor2: string; // '153044';
      textColor3: string; // '2a4a5f';
      textColor4: string; // '345266';
    };
    artistName: string; // 'Daniel Buechele';
    url: string; // 'https://podcasts.apple.com/us/podcast/luftpost-podcast/id409553739';
    subscribable: boolean;
    genreNames: string[]; // ['Places & Travel', 'Podcasts', 'Society & Culture', 'Sports', 'Wilderness'];
    createdDate: string; // '2010-12-11';
    trackCount: number;
    completed: boolean;
    seasonNumbers: [];
    name: string; // 'Luftpost Podcast';
    subscriptionUrl: string; // 'https://itunes.apple.com/WebObjects/DZR.woa/wa/subscribePodcast?cc=us&id=409553739';
    releaseDateTime: string; // '2020-08-28T20:38:00Z';
    languageTag: string; // 'de-DE';
    description: {
      standard: string; // 'Luftpost bringt in unregelmäßigen Abständen Interviews mit Leuten, die spannende Orte dieser Welt besucht haben. Gemeinsam sprechen wir über Kultur, Leben, Sehenswürdigkeiten und mehr Dinge, die es auf einer Reise dort zu erkunden gilt.';
    };
    websiteUrl: string; // 'https://luftpost-podcast.de';
    contentRating: string; // 'clean';
  };
  relationships: {
    artists: {
      href: string; // '/v1/catalog/us/podcasts/409553739/artists';
      data: [];
    };
  };
};

type AmpEpisode = {
  id: string; // '1000489471624';
  type: 'podcast-episodes';
  href: string; // '/v1/catalog/us/podcast-episodes/1000489471624';
  attributes: {
    artwork: {
      width: number;
      height: number;
      url: string; // 'https://is4-ssl.mzstatic.com/image/thumb/Podcasts113/v4/84/6e/74/846e740e-cb85-744e-8b5e-d8dc9a4b2c60/mza_7550981096815785933.png/{w}x{h}bb.{f}';
      bgColor: string; // 'b1dced';
      textColor1: string; // '08253c';
      textColor2: string; // '153044';
      textColor3: string; // '2a4a5f';
      textColor4: string; // '345266';
    };
    topics: [];
    artistName: string; // 'Daniel Buechele';
    url: string; // 'https://podcasts.apple.com/us/podcast/senegal/id409553739?i=1000489471624';
    subscribable: true;
    mediaKind: string; // 'audio';
    genreNames: string[]; // ['Places & Travel'];
    name: string; // 'Senegal';
    assetUrl: string; // 'https://luftpost-podcast.de/media/luftpost107-senegal.mp3';
    releaseDateTime: string; // '2020-08-28T20:38:26Z';
    durationInMilliseconds: number;
    guid: string; // 'https://luftpost-podcast.de/?p=1175';
    description: {
      standard: string; // 'Über Afrika ist auf meiner Landkarte immer noch etwas unterrepräsentiert, deshalb freut es mich um so mehr, dass ich mit Jessi über ihre Reise in den Senegal sprechen durfte. Sie war dort für drei Wochen mit ihrem Mann um dort in der Hauptstadt Dakar zum ersten Mal ihre Schwiegerfamilie zu treffen. Sie erzählt von der Gastfreundschaft und viel zu viel Essen, Ausflüge in die Wüste, Begegnungen mit Einheimischen und auch wie sie bei einer traditionellen Schlachtung eines Schafs mithelfen durfte/musste.';
      short: string; // 'Über Afrika ist auf meiner Landkarte immer noch etwas unterrepräsentiert, deshalb freut es mich um so mehr, dass ich mit Jessi über ihre Reise in den Senegal sprechen durfte. Sie war dort für drei Wochen mit ihrem Mann um dort in [...]';
    };
    websiteUrl: string; // 'https://luftpost-podcast.de/senegal/';
    contentRating: string; // 'clean';
  };
};

async function ampApiRequest<T>(
  url: string,
  retries: number = 3,
): Promise<{
  data: T[];
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

export async function ampPodcast(id: string | null) {
  if (!id) {
    return;
  }
  const result = await ampApiRequest<AmpPodcast>(
    `https://amp-api.podcasts.apple.com/v1/catalog/us/podcasts/${id}`,
  );
  if (result?.data?.length > 0) {
    return result.data[0];
  }
}

export async function ampEpisode(id: string | null) {
  if (!id) {
    return;
  }
  const result = await ampApiRequest<AmpEpisode>(
    `https://amp-api.podcasts.apple.com/v1/catalog/us/podcast-episodes/${id}`,
  );
  return result?.data?.find((episode) => episode.id === id);
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
