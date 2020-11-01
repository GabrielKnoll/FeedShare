import {fetchPage, ParserResult} from '../resolveShareUrl';
import URL from 'url';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://castro.fm/podcast/fc60896e-f790-4357-98a8-b8901270a0f8
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  if (type === 'itunes' && id) {
    // https://castro.fm/itunes/1172218725
    return {applePodcastId: id, type: 'Podcast'};
  }

  const $ = await fetchPage(url);
  const overcastLink = $(
    '#co-supertop-castro-open-in a[href^="https://overcast.fm/itunes"]',
  ).attr('href');
  if (overcastLink) {
    const [_, applePodcastId] =
      overcastLink.match(/https:\/\/overcast\.fm\/itunes(\d+)/) ?? [];

    if (!applePodcastId) {
      throw new Error('Castro: Unable to parse');
    }
    // const rssFeed = $('img[alt="Subscribe to RSS"]').parent().attr('href');

    if (type === 'episode') {
      let episodeTitle =
        $('#co-supertop-castro-metadata h1').text() || undefined;
      if (episodeTitle) {
        return {
          applePodcastId,
          episodeTitle,
          type: 'Episode',
        };
      }
    } else {
      return {
        applePodcastId,
        type: 'Podcast',
      };
    }
  }
  throw new Error('Castro: Unable to parse');
}
