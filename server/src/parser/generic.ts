import {Parser} from '../queries/resolveShareUrl';
import {iTunesPodcast} from '../utils/appleApi';
import fetchPage from '../utils/fetchPage';

const parser: Parser = async function (url) {
  const $ = await fetchPage(url);

  let itunesId: string | undefined;
  let feeds: string[] = [];

  // Smart App Banner: <meta name="apple-itunes-app" content="app-id=XXXXXXXXXX">
  const smartAppBanner = $('meta[name="apple-itunes-app"]').attr('content');
  const [_, id] = smartAppBanner?.match(/app-id=(\d+)/) ?? [];
  if (id) {
    const itunesPodcast = await iTunesPodcast(id);
    if (itunesPodcast) {
      itunesId = id;
      feeds.push(itunesPodcast.feedUrl);
    }
  }

  // find iTunes ID on page
  if (!itunesId) {
    itunesId = $('a[href*="apple.com/"]')
      .toArray()
      .map((el) => {
        if (el.type === 'tag') {
          const url = el.attribs['href'];
          if (url.includes('podcast')) {
            const [_, id] = url.match(/\Wid(\d+)/) ?? [];
            return id;
          }
        }
      })
      .filter(Boolean)
      .shift();
  }

  // try finding podcast from RSS feed
  feeds.push(
    ...$('link[type="application/rss+xml"]')
      .toArray()
      .map((e) => {
        if (e.type === 'tag') {
          return e.attribs['href'];
        }
        return '';
      })
      .filter(Boolean),
  );

  if (!itunesId && feeds.length === 0) {
    throw new Error('Generic: Unable to parse');
  }

  const singleAudio = $('audio').length === 1;
  const audioSrc = singleAudio ? $('audio').attr('src') : undefined;
  const sourceSrc = singleAudio ? $('audio source').attr('src') : undefined;

  const downloadLink = $('a[href$=".mp3"]');
  const downloadUrl =
    downloadLink.length === 1 ? downloadLink.attr('href') : undefined;

  const ogTitle = $('meta[property="og:title"]').attr('content');
  const pageTitle = $('title').text();

  return {
    feeds: feeds.length === 0 ? undefined : feeds,
    itunesId: itunesId ? parseInt(itunesId, 10) : undefined,
    enclosureUrl: audioSrc ?? sourceSrc ?? downloadUrl,
    episodeTitle: ogTitle ?? pageTitle,
  };
};

export default parser;
