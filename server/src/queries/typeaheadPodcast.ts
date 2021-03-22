import {extendType, nonNull, stringArg} from 'nexus';
import requireAuthorization from '../utils/requireAuthorization';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('typeaheadPodcast', {
      type: 'Podcast',
      args: {
        query: nonNull(stringArg()),
      },
      ...requireAuthorization,
      resolve: async (_root, {query}, {prismaClient}) => {
        const q = query.trim().replace(/\s/g, '<->') + ':*';

        return prismaClient.$queryRaw`
          SELECT "id", "title", "itunesId", "publisher", "artwork" FROM "Podcast"
            WHERE tsv @@ to_tsquery('simple', f_unaccent(${q}))
            ORDER BY ts_rank(tsv, to_tsquery('simple', f_unaccent(${q}))) DESC
            LIMIT 20;
        `;
      },
    });
  },
});
