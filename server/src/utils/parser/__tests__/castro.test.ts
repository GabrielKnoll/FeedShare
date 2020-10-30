import castro from '../castro';
import URL from 'url';

describe('Catro', () => {
  it('iTunes', async () => {
    const res = await castro(URL.parse('https://castro.fm/itunes/409553739'));
    expect(res).toEqual({
      applePodcastId: '409553739',
      type: 'Podcast',
    });
  });

  it('podcast', async () => {
    const res = await castro(
      URL.parse(
        'https://castro.fm/podcast/1acc1e64-6ea1-4f97-a4a2-c6cfb33ac726',
      ),
    );
    expect(res).toEqual({
      applePodcastId: '409553739',
      rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      type: 'Podcast',
    });
  });

  it('episode', async () => {
    const res = await castro(URL.parse('https://castro.fm/episode/Xrshui'));
    expect(res).toEqual({
      applePodcastId: '409553739',
      rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      type: 'Episode',
      episodeTitle: 'Senegal',
    });
  });
});
