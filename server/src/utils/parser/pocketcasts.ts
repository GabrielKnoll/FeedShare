import {fetchPage, ParserResult} from '../resolveAttachmentUrl';
import URL from 'url';
import {idFromAppleUrl} from './apple';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  //
  // https://pca.st/itunes/1172218725
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  let applePodcastId: string | undefined;
  let rssFeed: string | undefined;
  let episodeTitle: string | undefined;

  if (type === 'itunes') {
    applePodcastId = id;
  } else {
    // https://pca.st/FG3H
    // https://pca.st/podcast/d20aba20-25cf-012e-0587-00163e1b201c
    // https://pca.st/episode/e9efaa6f-08f6-4acc-934a-81430bd97013
    const $ = await fetchPage(url);
    rssFeed = $('.rss_button a').first().attr('href');
    applePodcastId = idFromAppleUrl($('.itunes_button a').first().attr('href'));
    episodeTitle =
      $('#episode_date').parent().children('h1').text() || undefined;
    if (episodeTitle) {
      type = 'episode';
    }
  }

  return {
    rssFeed,
    applePodcastId,
    episodeTitle,
    type: type === 'episode' ? 'Episode' : 'Podcast',
  };
}
