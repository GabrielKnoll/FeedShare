import {fetchPage, ParserResult} from '../resolveShareUrl';
import URL from 'url';
import {idFromAppleUrl} from './apple';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://overcast.fm/+HiEYDNrZs
  // https://overcast.fm/itunes1357986673
  // https://overcast.fm/itunes1357986673/tony-basilios-next-level-network-family-of-podcasts
  const [id] = (url.pathname ?? '').split('/').filter(Boolean);
  if (id?.startsWith('itunes')) {
    const [_, applePodcastId] = id.match(/^itunes(\d+)$/) ?? [];
    return {
      applePodcastId,
      type: 'Podcast',
    };
  }

  const $ = await fetchPage(url);
  const applePodcastId = idFromAppleUrl(
    $('.externalbadges a[href^="https://podcasts.apple.com/podcast/"]')
      .first()
      .attr('href'),
  );

  if (!applePodcastId) {
    throw new Error('Overcast: Unable to parse');
  }
  // const rssFeed = $('img[src="/img/badge-rss.svg"]').parent().attr('href');
  const episodeUrl = $('#audiotimestamplink')
    .parent()
    .children('a:contains("Website")')
    .attr('href');

  return {
    applePodcastId,
    episodeUrl,
    type: episodeUrl ? 'Episode' : 'Podcast',
  };
}
