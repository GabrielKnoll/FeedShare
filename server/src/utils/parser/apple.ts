import queryString from 'query-string';
import URL from 'url';
import {ParserResult} from '../../queries/resolveShareUrl';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://podcasts.apple.com/de/podcast/pakistan/id409553739?i=1000477131403&l=en?l=en&i=1000477131403
  let [country, podcast, episode, podcastID] = (url.pathname ?? '')
    .split('/')
    .filter(Boolean);
  let {i: id} = queryString.parse(url.search ?? '');

  const appleEpisodeId = (Array.isArray(id) ? id[0] : id) ?? undefined;
  const applePodcastId = podcastID?.replace(/^id/, '');

  if (!appleEpisodeId && !applePodcastId) {
    throw new Error('Apple: Unable to parse');
  }

  return {
    applePodcastId,
    appleEpisodeId,
    type: appleEpisodeId ? 'Episode' : 'Podcast',
  };
}

export function idFromAppleUrl(itunesUrl?: string): string | undefined {
  if (itunesUrl && URL.parse(itunesUrl).hostname === 'podcasts.apple.com') {
    const match = itunesUrl.match(/id(\d+)/) ?? [];
    return match[1];
  }
}
