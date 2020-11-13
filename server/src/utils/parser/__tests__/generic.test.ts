import generic from '../generic';
import URL from 'url';

describe('Generic', () => {
  it('RSS feed', async () => {
    const res = await generic(URL.parse('https://luftpost-podcast.de'));
    expect(res).toEqual({
      type: 'Podcast',
      applePodcastId: '409553739',
      podcastIndexPodcast: expect.objectContaining({
        title: 'Luftpost Podcast',
      }),
    });
  });

  it('iTunes link', async () => {
    const res = await generic(
      URL.parse(
        'https://www.nytimes.com/2020/11/12/podcasts/the-daily/pfizer-vaccine-coronavirus-BioNTech.html',
      ),
    );
    expect(res).toEqual({
      type: 'Podcast',
      applePodcastId: '1200361736',
    });
  });

  it('nothing', async () => {
    expect(generic(URL.parse('https://example.com'))).rejects.toThrowError();
  });
});
