import {extendType, stringArg} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';
import {findPodcast} from '../utils/podcastIndex';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('findPodcast', {
      list: true,
      nullable: true,
      type: 'Podcast',
      args: {
        query: stringArg({
          required: true,
        }),
      },
      ...requireAuthorization,
      resolve: async (_root, {query}) => findPodcast(query),
    });
  },
});
