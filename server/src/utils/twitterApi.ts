import fetch from 'node-fetch';
import queryString from 'query-string';
import {hmacsign} from 'oauth-sign';
import env from './env';

async function twitterApiRequest<T>(
  path: string,
  token: string,
  tokenSecret: string,
  qs: {[key: string]: string},
): Promise<{data: T}> {
  const timestamp = Math.round(new Date().getTime() / 1000);

  const url = 'https://api.twitter.com' + path;
  const nonce = Math.random().toString(36);
  const params = {
    oauth_consumer_key: env.TWITTER_COMSUMER_KEY,
    oauth_nonce: nonce,
    oauth_signature_method: 'HMAC-SHA1' as const,
    oauth_timestamp: String(timestamp),
    oauth_token: token,
    ...qs,
  };
  const method = 'GET';
  const oauth_signature = hmacsign(
    method,
    url,
    params,
    env.TWITTER_CONSUMER_SECRET,
    tokenSecret,
  );

  const a = Object.entries({
    ...params,
    oauth_signature: encodeURIComponent(oauth_signature),
  })
    .reduce<string[]>(
      (acc, [key, value]) => acc.concat([`${key}="${value}"`]),
      [],
    )
    .join(', ');

  const result = await fetch(`${url}?${queryString.stringify(qs)}`, {
    method,
    headers: {
      Authorization: `OAuth ${a}`,
    },
  });
  if (result.ok) {
    return await result.json();
  }

  const text = await result.text();
  throw new Error(`${result.status} ${result.statusText}\n${text}`);
}

export async function twitterProfile(
  id: string,
  token: string,
  tokenSecret: string,
) {
  return await twitterApiRequest<{
    name: string;
    username: string;
    profile_image_url: string;
    id: string;
  }>('/2/users/' + id, token, tokenSecret, {
    'user.fields': 'profile_image_url',
  });
}
