import {objectType} from 'nexus/components/schema';
import parseToken from '../utils/parseToken';
import {schema} from 'nexus';
import requireAuthorization from '../utils/requireAuthorization';

schema.extendType({
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
      resolve: async (_, _args, {db, token}) => ({
        user: await db.user.findOne({
          where: {
            id: parseToken(token).userId,
          },
        }),
        personalFeed: 'https://feed.buechele.cc/feed',
      }),
    });
  },
});
