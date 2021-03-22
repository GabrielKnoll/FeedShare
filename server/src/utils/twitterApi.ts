import queryString, {StringifiableRecord} from 'query-string';
import {dataCallback, OAuth} from 'oauth';
import env from './env';

const oauth = new OAuth(
  'https://api.twitter.com/oauth/request_token',
  'https://api.twitter.com/oauth/access_token',
  env.TWITTER_CONSUMER_KEY,
  env.TWITTER_CONSUMER_SECRET,
  '1.0A',
  null,
  'HMAC-SHA1',
);

async function twitterApiRequest<T>(
  path: string,
  token: string,
  tokenSecret: string,
  qs: StringifiableRecord = {},
  method: 'GET' | 'POST' = 'GET',
): Promise<T> {
  // remove undefined properties from qs
  Object.keys(qs).forEach((key) => qs[key] === undefined && delete qs[key]);

  const url = `https://api.twitter.com${path}?${
    qs ? queryString.stringify(qs) : ''
  }`;

  return new Promise((resolve, reject) => {
    const cb: dataCallback = (error, result) => {
      if (error) {
        reject(error);
      }
      const data = JSON.parse(String(result));
      resolve(data);
    };
    if (method === 'POST') {
      oauth.post(url, token, tokenSecret, null, undefined, cb);
    } else {
      oauth.get(url, token, tokenSecret, cb);
    }
  });
}

export async function twitterProfile(
  id: string,
  token: string,
  tokenSecret: string,
) {
  const res = await twitterApiRequest<{
    data: {
      name: string;
      username: string;
      profile_image_url: string;
      id: string;
    };
  }>('/2/users/' + id, token, tokenSecret, {
    'user.fields': 'profile_image_url',
  });
  // rewrite URL to full size image
  res.data.profile_image_url = res.data.profile_image_url.replace(
    /_normal\.jpg$/,
    '.jpg',
  );
  return res;
}

export async function twitterFollowing(token: string, tokenSecret: string) {
  const allIds: string[] = [];
  let cursor: string | undefined;
  while (cursor !== '0') {
    const {ids, next_cursor_str} = await twitterApiRequest<{
      ids: string[];
      next_cursor: number;
      next_cursor_str: string;
      previous_cursor: number;
      previous_cursor_str: string;
    }>('/1.1/friends/ids.json', token, tokenSecret, {
      stringify_ids: 'true',
      cursor,
    });
    cursor = next_cursor_str;
    allIds.push(...ids);
  }
  return allIds;
}

export async function sendTweet(
  token: string,
  tokenSecret: string,
  content: string,
) {
  return twitterApiRequest(
    '/1.1/statuses/update.json',
    token,
    tokenSecret,
    {
      status: content,
    },
    'POST',
  );
}
