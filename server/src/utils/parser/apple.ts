import queryString from 'query-string';
import {PodcastInfo} from '../resolveAttachmentUrl';
import URL from 'url';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<PodcastInfo> {
  // https://podcasts.apple.com/de/podcast/pakistan/id409553739?i=1000477131403&l=en?l=en&i=1000477131403
  let [country, podcast, episode, podcastID] = (url.pathname ?? '')
    .split('/')
    .filter(Boolean);
  let {i: id} = queryString.parse(url.search ?? '');

  return {
    applePodcastId: podcastID.replace(/^id/, ''),
    appleEpisodeId: (Array.isArray(id) ? id[0] : id) ?? undefined,
  };
}

export function idFromAppleUrl(itunesUrl?: string): string | undefined {
  if (itunesUrl && URL.parse(itunesUrl).hostname === 'podcasts.apple.com') {
    const match = itunesUrl.match(/id(\d+)/) ?? [];
    return match[1];
  }
}
