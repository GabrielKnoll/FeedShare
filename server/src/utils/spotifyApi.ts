import fetch from 'node-fetch';
import env from './env';

let accessToken: string | null = null;
let accessTokenExpiry = new Date();

async function spotifyApiToken() {
  if (accessToken && accessTokenExpiry > new Date()) {
    return accessToken;
  }
  const data:
    | {
        access_token: string;
        token_type: 'Bearer';
        expires_in: number;
        scope: string;
      }
    | undefined = await fetch('https://accounts.spotify.com/api/token', {
    method: 'POST',
    headers: {
      'content-type': 'application/x-www-form-urlencoded',
    },
    body: `grant_type=client_credentials&client_id=${env.SPOTIFY_CLIENT_ID}&client_secret=${env.SPOTIFY_CLIENT_SECRET}`,
  })
    .then((res) => res.json())
    .catch(() => undefined);

  if (data) {
    accessToken = data.access_token;
    accessTokenExpiry = new Date(new Date().getTime() + data.expires_in * 1000);
    return accessToken;
  }
}

export async function spotifyApiRequest<T extends 'show' | 'episode'>(
  type: T,
  id: string,
  retries?: number,
): Promise<
  | undefined
  | (T extends 'show' ? SpotifyAPI.ShowsResponse : SpotifyAPI.EpisodesReponse)
> {
  retries = retries ?? 3;
  const token = await spotifyApiToken();
  if (!token) {
    return;
  }

  const res = await fetch(
    `https://api.spotify.com/v1/${type}s/${id}?market=US`,
    {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    },
  );

  if (!res.ok) {
    accessToken = null;
    if (retries > 0) {
      return spotifyApiRequest(type, id, retries - 1);
    }
  }

  const data = await res.json();

  if (data.error) {
    return;
  }
  return data;
}
