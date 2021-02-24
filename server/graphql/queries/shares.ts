import {AuthenticationError, UserInputError} from 'apollo-server-micro';
import {extendType, nonNull} from 'nexus';
import {shareWhere} from '../models/Share';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.nonNull.connectionField('shares', {
      type: 'Share',
      additionalArgs: {
        feedType: nonNull('FeedType'),
      },
      resolve: async (_parent, args, ctx) => {
        if (!args.last || args.last < 0) {
          throw new UserInputError('last is less than 0');
        }
        if (!ctx.userId && args.feedType !== 'Global') {
          throw new AuthenticationError('Not authorized');
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
