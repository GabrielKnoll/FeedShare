import {extendType, intArg, nonNull, stringArg} from 'nexus';
import requireAuthorization from '../../utils/requireAuthorization';
import {typeaheadPodcast} from '../../utils/podcastIndex';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('typeaheadPodcast', {
      type: 'Podcast',
      args: {
        query: nonNull(stringArg()),
      },
      ...requireAuthorization,
      resolve: async (_root, {query}) => typeaheadPodcast(query),
    });
  },
});
