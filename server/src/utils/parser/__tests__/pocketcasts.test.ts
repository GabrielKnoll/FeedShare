import pocketcasts from '../pocketcasts';
import URL from 'url';

describe('PocketCasts', () => {
  it('iTunes', async () => {
    const res = await pocketcasts(URL.parse('https://pca.st/itunes/409553739'));
    expect(res).toEqual({
      applePodcastId: '409553739',
      type: 'Podcast',
    });
  });

  it('podcast', async () => {
    const res = await pocketcasts(
      URL.parse('https://pca.st/podcast/d20aba20-25cf-012e-0587-00163e1b201c'),
    );
    expect(res).toEqual({
      applePodcastId: '409553739',
      rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      type: 'Podcast',
    });
  });

  it('episode', async () => {
    const res = await pocketcasts(
      URL.parse('https://pca.st/episode/e9efaa6f-08f6-4acc-934a-81430bd97013'),
    );
    expect(res).toEqual({
      applePodcastId: '409553739',
      episodeTitle: 'Senegal',
      rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      type: 'Episode',
    });
  });

  it('short URL podcast', async () => {
    const res = await pocketcasts(URL.parse('https://pca.st/FG3H'));
    expect(res).toEqual({
      applePodcastId: '409553739',
      rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      type: 'Podcast',
    });
  });

  it('short URL episode', async () => {
    const res = await pocketcasts(URL.parse('https://pca.st/5ed1le8o'));
    expect(res).toEqual({
      applePodcastId: '409553739',
      episodeTitle: 'Senegal',
      rssFeed: 'https://luftpost-podcast.de/feed/podcast/',
      type: 'Episode',
    });
  });
});
