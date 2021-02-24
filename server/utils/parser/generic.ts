import {Parser} from '../../graphql/queries/resolveShareUrl';
import fetchPage from '../fetchPage';

const parser: Parser = async function (url) {
  const $ = await fetchPage(url);

  let itunesId: string | undefined;
  // Smart App Banner: <meta name="apple-itunes-app" content="app-id=XXXXXXXXXX">
  const smartAppBanner = $('meta[name="apple-itunes-app"]').attr('content');
  const [_, id] = smartAppBanner?.match(/app-id=(\d+)/) ?? [];
  itunesId = id;

  // find iTunes ID on page
  if (!itunesId) {
    itunesId = $('a[href*="apple.com/"]')
      .toArray()
      .map((el) => {
        const url = el.attribs['href'];
        if (url.includes('podcast')) {
          const [_, id] = url.match(/\Wid(\d+)/) ?? [];
          return id;
        }
      })
      .filter(Boolean)
      .shift();
  }

  let feeds: string[] | undefined;
  // try finding podcast from RSS feed
  if (!itunesId) {
    feeds = $('link[type="application/rss+xml"]')
      .toArray()
      .map((e) => e.attribs['href'])
      .filter(Boolean);
  }

  if (!itunesId && !feeds) {
    throw new Error('Generic: Unable to parse');
  }

  const audioSrc = $('audio').attr('src');
  const sourceSrc = $('audio source').attr('src');
  const downloadLink = $('a[href$=".mp3"]').attr('href');

  const ogTitle = $('meta[property="og:title"]').attr('content');
  const pageTitle = $('title').text();

  return {
    feeds,
    itunesId: itunesId ? parseInt(itunesId, 10) : undefined,
    enclosureUrl: audioSrc ?? sourceSrc ?? downloadLink,
    episodeTitle: ogTitle ?? pageTitle,
  };
};

export default parser;
