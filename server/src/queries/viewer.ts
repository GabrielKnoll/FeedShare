import {extendType} from '@nexus/schema';
import {getViewer} from '../models/Viewer';
import requireAuthorization from '../utils/requireAuthorization';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('viewer', {
      type: 'Viewer',
      ...requireAuthorization,
      resolve: async (_root, _args, ctx) => {
        const user = await ctx.prismaClient.user.findOne({
          where: {
            id: ctx.userId,
          },
        });

        if (!user) {
          throw new Error('User does not exist');
        }

        return getViewer(user, ctx);
      },
    });
  },
});