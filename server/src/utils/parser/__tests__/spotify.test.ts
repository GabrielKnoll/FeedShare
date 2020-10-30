import spotify from '../spotify';
import URL from 'url';

describe('Spotify', () => {
  it('show', async () => {
    const res = await spotify(
      URL.parse(
        'https://open.spotify.com/show/6Hlfm1o9ynlT5Ex8ZvGxk9?si=-N9tm5ZUTP6zAGWESmAXNA',
      ),
    );
    expect(res).toEqual({
      type: 'Podcast',
      spotifyPodcastId: '6Hlfm1o9ynlT5Ex8ZvGxk9',
    });
  });

  it('episode', async () => {
    const res = await spotify(
      URL.parse(
        'https://open.spotify.com/episode/55gZ1maECkQeb3j5hQjxEq?si=kBfIC3cmRhiYLsNV0LXAVg',
      ),
    );
    expect(res).toEqual({
      type: 'Episode',
      spotifyEpisodeId: '55gZ1maECkQeb3j5hQjxEq',
    });
  });
});
