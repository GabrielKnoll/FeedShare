import pocketcasts from '../pocketcasts';
import expectParserResult from '../_expectParserResult';

describe('Pocketcasts', () => {
  expectParserResult(pocketcasts, [
    [
      'https://pca.st/itunes/409553739',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://pca.st/podcast/d20aba20-25cf-012e-0587-00163e1b201c',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://pca.st/episode/e9efaa6f-08f6-4acc-934a-81430bd97013',
      {
        episodeTitle: 'Senegal',
        itunesId: 409553739,
      },
    ],
    [
      'https://pca.st/FG3H',
      {
        itunesId: 409553739,
      },
    ],
    [
      'https://pca.st/5ed1le8o',
      {
        itunesId: 409553739,
        episodeTitle: 'Senegal',
      },
    ],
  ]);
});
