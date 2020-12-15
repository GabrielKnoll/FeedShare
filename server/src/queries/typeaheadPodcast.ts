import {extendType, nonNull, stringArg} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';
import {typeaheadPodcast} from '../utils/podcastIndex';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('typeaheadPodcast', {
      type: 'SearchResult',
      args: {
        query: nonNull(stringArg()),
      },
      ...requireAuthorization,
      resolve: async (_root, {query}) => typeaheadPodcast(query),
    });
  },
});
