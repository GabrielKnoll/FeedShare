import URL from 'url';
import {ParserResult} from '../../queries/resolveShareUrl';
import fetchPage from '../fetchPage';
import {ApiResponse} from 'podcastdx-client/dist/types';
import podcastIndexClient from '../podcastIndexClient';

export default async function (
  url: URL.UrlWithStringQuery,
): Promise<ParserResult> {
  // find iTunes ID on page
  const $ = await fetchPage(url);
  let applePodcastId = $('a[href*="apple.com/"]')
    .toArray()
    .map((el) => {
      const link = URL.parse(el.attribs['href']);
      if (link.hostname?.endsWith('apple.com')) {
        const matches = link.path?.match(/\Wid(\d+)\W/) ?? [];
        return matches[1];
      }
    })
    .filter(Boolean)
    .pop();

  let podcastIndexPodcast: ApiResponse.PodcastFeed | undefined;
  if (!applePodcastId) {
    // try finding podcast from RSS feed
    podcastIndexPodcast = await Promise.all(
      $('link[type="application/rss+xml"]')
        .toArray()
        .map(async (el) => {
          let res: ApiResponse.Podcast | undefined;
          try {
            res = await podcastIndexClient.podcastByUrl(el.attribs['href']);
          } catch (e) {
            console.error(e);
          }
          if (res) {
            throw res;
          }
        }),
    )
      .then(() => undefined)
      .catch((result: ApiResponse.Podcast) => result?.feed);
    applePodcastId = podcastIndexPodcast?.itunesId?.toString();
  }

  if (!applePodcastId) {
    throw new Error('Generic: Unable to parse');
  }

  return {
    applePodcastId,
    podcastIndexPodcast,
    type: 'Podcast',
  };
}
