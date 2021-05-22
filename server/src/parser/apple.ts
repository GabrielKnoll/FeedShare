import queryString from 'query-string';
import URL from 'url';
import {Parser} from '../queries/resolveShareUrl';
import {ampEpisode} from '../utils/appleApi';

const parser: Parser = async function (url) {
  // https://podcasts.apple.com/de/podcast/pakistan/id409553739?i=1000477131403&l=en?l=en&i=1000477131403
  let [_country, _podcast, _episode, podcastID] = (url.pathname ?? '')
    .split('/')
    .filter(Boolean);
  let {i: id} = queryString.parse(url.search ?? '');

  const iid = podcastID?.replace(/^id/, '');
  if (!iid) {
    throw new Error('Apple: Unable to parse');
  }
  const itunesId = parseInt(iid, 10);
  const appleEpisodeId = (Array.isArray(id) ? id[0] : id) ?? undefined;

  let enclosureUrl: string | undefined;
  if (appleEpisodeId) {
    const episode = await ampEpisode(appleEpisodeId);
    enclosureUrl = episode?.attributes.assetUrl;
  }

  return {
    itunesId,
    enclosureUrl,
  };
};

export function idFromAppleUrl(itunesUrl?: string): string | undefined {
  if (itunesUrl && URL.parse(itunesUrl).hostname === 'podcasts.apple.com') {
    const match = itunesUrl.match(/id(\d+)/) ?? [];
    return match[1];
  }
}

export default parser;
