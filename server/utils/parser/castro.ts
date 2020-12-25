import URL from 'url';
import {ParserResult} from '../../graphql/queries/resolveShareUrl';
import fetchPage from '../fetchPage';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://castro.fm/podcast/fc60896e-f790-4357-98a8-b8901270a0f8
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  if (type === 'itunes' && id) {
    // https://castro.fm/itunes/1172218725
    return {itunesId: parseInt(id, 10)};
  }

  const $ = await fetchPage(url);
  const overcastLink = $(
    '#co-supertop-castro-open-in a[href^="https://overcast.fm/itunes"]',
  ).attr('href');
  if (overcastLink) {
    const [_, iid] =
      overcastLink.match(/https:\/\/overcast\.fm\/itunes(\d+)/) ?? [];
    const itunesId = parseInt(iid, 10);

    if (!itunesId) {
      throw new Error('Castro: Unable to parse');
    }
    // const rssFeed = $('img[alt="Subscribe to RSS"]').parent().attr('href');
    let episodeTitle: string | undefined;
    if (type === 'episode') {
      episodeTitle = $('#co-supertop-castro-metadata h1').text() || undefined;
    }

    return {
      itunesId,
      episodeTitle,
    };
  }
  throw new Error('Castro: Unable to parse');
}
