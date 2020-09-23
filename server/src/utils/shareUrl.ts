import queryString from 'query-string';

export default function (shareUrl: string) {
  const url = new URL(shareUrl);

  switch (url.hostname) {
    case 'podcasts.apple.com': {
      // https://podcasts.apple.com/de/podcast/pakistan/id409553739?i=1000477131403&l=en?l=en&i=1000477131403
      let [country, podcast, episode, podcastID] = url.pathname
        .split('/')
        .filter(Boolean);
      podcastID = podcastID.replace(/^id/, '');
      const {i: episodeID} = queryString.parse(url.search);
    }
    default: {
      throw new Error(`Unknown share URL: ${url}`);
    }
  }
}

async function podastLookup(id: string) {
  const res = await fetch(`https://itunes.apple.com/lookup?id=${id}`);
  const data: {
    resultCount: number;
    results: Array<{
      feedUrl: string;
      artistName: string;
      artworkUrl30: string;
      artworkUrl60: string;
      artworkUrl100: string;
      artworkUrl600: string;
    }>;
  } = await res.json();
}
