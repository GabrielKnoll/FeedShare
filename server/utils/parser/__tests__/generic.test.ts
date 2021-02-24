import generic from '../generic';
import expectParserResult from '../_expectParserResult';

describe('Generic', () => {
  expectParserResult(generic, [
    [
      'https://luftpost-podcast.de/antarktis/',
      {
        feeds: ['https://luftpost-podcast.de/feed/podcast/'],
        enclosureUrl:
          'https://luftpost-podcast.de/media/luftpost108-antarktis.mp3',
        episodeTitle: 'Antarktis',
      },
    ],
    [
      'https://www.nytimes.com/2020/11/12/podcasts/the-daily/pfizer-vaccine-coronavirus-BioNTech.html',
      {
        itunesId: 1200361736,
        episodeTitle: 'A Vaccine Breakthrough',
      },
    ],
    [
      'https://gimletmedia.com/shows/reply-all/awheda3/173-the-test-kitchen-chapter-2',
      {
        itunesId: 941907967,
        episodeTitle: '#173 The Test Kitchen, Chapter 2 | Reply All',
      },
    ],
  ]);
});
