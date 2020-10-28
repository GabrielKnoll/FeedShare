declare module 'oauth-sign' {
  interface Params {
    oauth_consumer_key: string;
    oauth_nonce: string;
    oauth_signature_method: 'HMAC-SHA1';
    oauth_timestamp: string;
    oauth_token: string;
    [key: string]: any;
  }

  function hmacsign(
    method: 'GET' | 'POST',
    url: string,
    params: Params,
    consumerSecret: string,
    tokenSecret: string,
  ): string;
}
