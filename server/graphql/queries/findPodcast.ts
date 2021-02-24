import {extendType, nonNull, stringArg} from 'nexus';
import requireAuthorization from '../../utils/requireAuthorization';
import {findPodcast} from '../../utils/podcastIndex';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('findPodcast', {
      type: 'Podcast',
      args: {
        query: nonNull(stringArg()),
      },
      ...requireAuthorization,
      resolve: async (_root, {query}) => findPodcast(query),
    });
  },
});
