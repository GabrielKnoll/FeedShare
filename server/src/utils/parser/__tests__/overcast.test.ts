import overcast from '../overcast';
import URL from 'url';

describe('Overcast', () => {
  it('iTunes', async () => {
    const res = await overcast(
      URL.parse('https://overcast.fm/itunes409553739'),
    );
    expect(res).toEqual({
      applePodcastId: '409553739',
      type: 'Podcast',
    });
  });

  it('episode', async () => {
    const res = await overcast(URL.parse('https://overcast.fm/+U9tgxn6k'));
    expect(res).toEqual({
      applePodcastId: '409553739',
      // rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      episodeUrl: 'https://luftpost-podcast.de/senegal/',
      type: 'Episode',
    });
  });

  it('garbage', async () => {
    expect(
      overcast(URL.parse('https://overcast.fm/garbage')),
    ).rejects.toThrowError();
  });
});
