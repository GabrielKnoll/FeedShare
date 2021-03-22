import castro from '../castro';
import expectParserResult from '../_expectParserResult';

describe('Castro', () => {
  expectParserResult(castro, [
    [
      'https://castro.fm/itunes/409553739',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://castro.fm/podcast/1acc1e64-6ea1-4f97-a4a2-c6cfb33ac726',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://castro.fm/episode/Xrshui',
      {
        itunesId: 409553739,
        episodeTitle: 'Senegal',
      },
    ],
    [
      'https://castro.fm/episode/Nxvucc',
      {
        itunesId: 803237839,
        episodeTitle: 'WR1198 Lauers Bureau 2021',
      },
    ],
  ]);
});
