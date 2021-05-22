import apple from '../apple';
import expectParserResult from '../_expectParserResult';

describe('Apple', () => {
  expectParserResult(apple, [
    [
      'https://podcasts.apple.com/de/podcast/luftpost-podcast/id409553739',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://podcasts.apple.com/de/podcast/senegal/id409553739?i=1000489471624',
      {
        itunesId: 409553739,
        enclosureUrl:
          'https://luftpost-podcast.de/media/luftpost107-senegal.mp3',
      },
    ],
  ]);
});
