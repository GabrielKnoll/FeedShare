import URL from 'url';
import {ParserResult} from '../../queries/resolveShareUrl';
import fetchPage from '../fetchPage';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // find iTunes ID on page
  const $ = await fetchPage(url);
  const itunesId = $('a[href*="apple.com/"]')
    .toArray()
    .map((el) => {
      const link = URL.parse(el.attribs['href']);
      if (link.hostname?.endsWith('apple.com')) {
        const matches = link.path?.match(/\Wid(\d+)\W/) ?? [];
        if (matches.length > 0) {
          return parseInt(matches[1], 10);
        }
      }
    })
    .filter(Boolean)
    .pop();

  if (itunesId) {
    return {
      itunesId,
    };
  }

  // try finding podcast from RSS feed
  const feeds = $('link[type="application/rss+xml"]')
    .toArray()
    .map((e) => e.attribs['href'])
    .filter(Boolean);

  if (feeds.length > 0) {
    return {
      feeds,
    };
  }

  throw new Error('Generic: Unable to parse');
}
