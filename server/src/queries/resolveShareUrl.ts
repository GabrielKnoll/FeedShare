import {extendType, stringArg, objectType} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';
import resolveShareUrl from '../utils/resolveShareUrl';
import {Episode} from '@prisma/client';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('resolveShareUrl', {
      type: objectType({
        name: 'ResolvedShareUrl',
        definition(t) {
          t.field('episode', {
            type: 'Episode',
            nullable: true,
          });
          t.field('podcast', {
            type: 'Podcast',
            nullable: true,
          });
        },
      }),
      args: {
        url: stringArg({
          required: true,
        }),
      },
      ...requireAuthorization,
      resolve: async (_root, {url}) => {
        const {episode, podcast} = await resolveShareUrl(url);
        const latestEpisodes: Episode[] = [];
        return {
          episode,
          podcast: podcast ? {...podcast, latestEpisodes} : undefined,
        };
        return {};
      },
    });
  },
});
