import apple from '../apple';
import URL from 'url';

describe('Apple', () => {
  it('podcast', async () => {
    const res = await apple(
      URL.parse(
        'https://podcasts.apple.com/de/podcast/luftpost-podcast/id409553739',
      ),
    );
    expect(res).toEqual({
      applePodcastId: '409553739',
      type: 'Podcast',
    });
  });

  it('episode', async () => {
    const res = await apple(
      URL.parse(
        'https://podcasts.apple.com/de/podcast/senegal/id409553739?i=1000489471624',
      ),
    );
    expect(res).toEqual({
      applePodcastId: '409553739',
      appleEpisodeId: '1000489471624',
      type: 'Episode',
    });
  });
});
