import {fetchPage, PodcastInfo} from '../resolveAttachmentUrl';
import URL from 'url';
import {idFromAppleUrl} from './apple';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<PodcastInfo> {
  // https://pca.st/itunes/1172218725
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  let applePodcastId: string | undefined;
  let rssFeed: string | undefined;

  if (type === 'itunes') {
    applePodcastId = id;
  } else {
    // https://pca.st/63et
    const $ = await fetchPage(url);
    rssFeed = $('.rss_button a').first().attr('href');
    applePodcastId = idFromAppleUrl($('.itunes_button a').first().attr('href'));
  }

  return {
    rssFeed,
    applePodcastId,
  };
}
