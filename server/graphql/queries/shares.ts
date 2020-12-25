import {
  objectType,
  extendType,
  stringArg,
  nonNull,
  intArg,
} from '@nexus/schema';
import FeedType from '../models/FeedType';
import PageInfo from '../models/PageInfo';
import requireAuthorization from '../../utils/requireAuthorization';
import {shareWhere} from '../models/Share';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.nonNull.field('shares', {
      type: objectType({
        name: 'ShareConnection',
        definition(t) {
          t.field('pageInfo', {
            type: PageInfo,
          });
          t.list.field('edges', {
            type: objectType({
              name: 'ShareEdge',
              definition(t) {
                t.string('cursor');
                t.field('node', {type: 'Share'});
              },
            }),
          });
        },
      }),
      args: {
        last: nonNull(intArg()),
        after: stringArg(),
        before: stringArg(),
        feedType: FeedType,
      },
      ...requireAuthorization,
      resolve: async (_parent, args, ctx) => {
        if (args?.last < 0) {
          throw new Error('last is less than 0');
        }

        let skip, cursor;
        const take = args.last + 1;

        if (args.before) {
          skip = 1;
          cursor = {id: args.before};
        }

        let nodes = await ctx.prismaClient.share.findMany({
          take,
          skip,
          cursor,
          where: await shareWhere(ctx, args.feedType),
          orderBy: {
            createdAt: 'desc',
          },
        });
        const hasExtraNode = nodes.length === take;

        // Remove the extra node from the results
        if (hasExtraNode) {
          nodes.pop();
        }

        // cut off list before the cursor
        if (args.after) {
          let found = false;
          const cursor = args.after;
          nodes = nodes.filter((n) => {
            found = found || n.id === cursor;
            return !found;
          });
        }

        nodes = nodes.reverse();

        // Get the start and end cursors
        const startCursor = nodes.length > 0 ? nodes[0].id : undefined;
        const endCursor =
          nodes.length > 0 ? nodes[nodes.length - 1].id : undefined;
        const hasPreviousPage = hasExtraNode;
        const hasNextPage = (skip ?? 0) > 0;

        return {
          pageInfo: {
            startCursor,
            endCursor,
            hasNextPage,
            hasPreviousPage,
          },
          edges: nodes.map((node) => ({cursor: node.id, node})),
        };
      },
    });
  },
});
