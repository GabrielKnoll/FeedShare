import {ParserResult} from '../resolveAttachmentUrl';
import URL from 'url';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://open.spotify.com/show/6Hlfm1o9ynlT5Ex8ZvGxk9?si=-N9tm5ZUTP6zAGWESmAXNA
  // https://open.spotify.com/episode/55gZ1maECkQeb3j5hQjxEq?si=kBfIC3cmRhiYLsNV0LXAVg
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  if (type !== 'show' && type !== 'episode') {
    throw new Error(`Spotify: unknown type ${type}`);
  }

  return {
    spotifyPodcastId: type === 'show' ? id : undefined,
    spotifyEpisodeId: type === 'episode' ? id : undefined,
    type: type === 'episode' ? 'Episode' : 'Podcast',
  };
}
