import {objectType, extendType} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('viewer', {
      type: objectType({
        name: 'Viewer',
        definition(t) {
          t.field('user', {
            type: 'User',
          });
          t.field('personalFeed', {
            type: 'String',
          });
        },
      }),
      ...requireAuthorization,
      resolve: async (_root, _args, {prismaClient, userId}) => {
        return {
          user: await prismaClient.user.findOne({
            where: {
              id: userId,
            },
          }),
          personalFeed: 'https://feed.buechele.cc/feed',
        };
      },
    });
  },
});
