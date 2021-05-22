import {idFromAppleUrl} from './apple';
import {Parser} from '../queries/resolveShareUrl';
import fetchPage from '../utils/fetchPage';

const parser: Parser = async function (url) {
  // https://overcast.fm/+HiEYDNrZs
  // https://overcast.fm/itunes1357986673
  // https://overcast.fm/itunes1357986673/tony-basilios-next-level-network-family-of-podcasts
  const [id] = (url.pathname ?? '').split('/').filter(Boolean);
  if (id?.startsWith('itunes')) {
    const [_, iid] = id.match(/^itunes(\d+)$/) ?? [];
    const itunesId = parseInt(iid, 10);

    return {
      itunesId,
    };
  }

  const $ = await fetchPage(url);
  const iid = idFromAppleUrl(
    $('.externalbadges a[href^="https://podcasts.apple.com/podcast/"]')
      .first()
      .attr('href'),
  );
  if (!iid) {
    throw new Error('Overcast: Unable to parse');
  }
  const itunesId = parseInt(iid, 10);

  // const rssFeed = $('img[src="/img/badge-rss.svg"]').parent().attr('href');
  const episodeUrl = $('#audiotimestamplink')
    .parent()
    .children('a:contains("Website")')
    .attr('href');

  const enclosureUrl = $('#audioplayer source').attr('src');

  return {
    itunesId,
    episodeUrl,
    enclosureUrl,
  };
};

export default parser;
