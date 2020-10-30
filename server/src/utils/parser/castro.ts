import {fetchPage, ParserResult} from '../resolveAttachmentUrl';
import URL from 'url';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // https://castro.fm/podcast/fc60896e-f790-4357-98a8-b8901270a0f8
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  if (type === 'itunes') {
    // https://castro.fm/itunes/1172218725
    return {applePodcastId: id, type: 'Podcast'};
  }

  const $ = await fetchPage(url);
  const overcastLink = $(
    '#co-supertop-castro-open-in a[href^="https://overcast.fm/itunes"]',
  );
  let applePodcastId: string | undefined;
  let episodeTitle: string | undefined;
  if (overcastLink.length > 0) {
    const podcastId =
      overcastLink.attr('href')?.match(/https:\/\/overcast\.fm\/itunes(\d+)/) ??
      [];
    applePodcastId = podcastId[1];
  }

  if (type === 'episode') {
    episodeTitle = $('#co-supertop-castro-metadata h1').text() || undefined;
  }

  return {
    rssFeed: $('img[alt="Subscribe to RSS"]').parent().attr('href'),
    applePodcastId,
    episodeTitle,
    type: type === 'episode' ? 'Episode' : 'Podcast',
  };
}
