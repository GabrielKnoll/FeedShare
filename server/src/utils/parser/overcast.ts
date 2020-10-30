import {fetchPage, ParserResult} from '../resolveAttachmentUrl';
import URL from 'url';
import {idFromAppleUrl} from './apple';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://overcast.fm/+HiEYDNrZs
  // https://overcast.fm/itunes1357986673
  // https://overcast.fm/itunes1357986673/tony-basilios-next-level-network-family-of-podcasts
  let [itunes] = (url.pathname ?? '').split('/').filter(Boolean);
  const podcastId = itunes.match(/^itunes(\d+)$/) ?? [];
  let applePodcastId: string | undefined = podcastId[1];
  let rssFeed: string | undefined;
  let episodeUrl: string | undefined;

  if (applePodcastId) {
    return {
      applePodcastId,
      type: 'Podcast',
    };
  }

  const $ = await fetchPage(url);
  applePodcastId = idFromAppleUrl(
    $('.externalbadges a[href^="https://podcasts.apple.com/podcast/"]')
      .first()
      .attr('href'),
  );
  rssFeed = $('img[src="/img/badge-rss.svg"]').parent().attr('href');
  episodeUrl = $('#audiotimestamplink')
    .parent()
    .children('a:contains("Website")')
    .attr('href');

  return {
    rssFeed,
    applePodcastId,
    episodeUrl,
    type: episodeUrl ? 'Episode' : 'Podcast',
  };
}
