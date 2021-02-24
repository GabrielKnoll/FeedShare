import {idFromAppleUrl} from './apple';
import {Parser} from '../../graphql/queries/resolveShareUrl';
import fetchPage from '../fetchPage';

const parser: Parser = async function (url) {
  //
  // https://pca.st/itunes/1172218725
  let [type, id] = (url.pathname ?? '').split('/').filter(Boolean);

  if (type === 'itunes' && id) {
    return {
      itunesId: parseInt(id, 10),
    };
  }

  // https://pca.st/FG3H
  // https://pca.st/podcast/d20aba20-25cf-012e-0587-00163e1b201c
  // https://pca.st/episode/e9efaa6f-08f6-4acc-934a-81430bd97013
  const $ = await fetchPage(url);
  // const rssFeed = $('.rss_button a').first().attr('href');
  const iid = idFromAppleUrl($('.itunes_button a').first().attr('href'));

  if (!iid) {
    throw new Error('PocketCasts: unable to parse');
  }
  const itunesId = parseInt(iid, 10);

  const episodeTitle =
    $('#episode_date').parent().children('h1').text() || undefined;

  return {
    itunesId,
    episodeTitle,
  };
};

export default parser;
