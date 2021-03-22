import overcast from '../overcast';
import expectParserResult from '../_expectParserResult';

describe('Overcast', () => {
  expectParserResult(overcast, [
    [
      'https://overcast.fm/itunes409553739',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://overcast.fm/+U9tgxn6k',
      {
        itunesId: 409553739,
        episodeUrl: 'https://luftpost-podcast.de/senegal/',
        enclosureUrl:
          'https://luftpost-podcast.de/media/luftpost107-senegal.mp3#t=0',
      },
    ],
  ]);
});
