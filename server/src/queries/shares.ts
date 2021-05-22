import {PrismaClient, Share} from '@prisma/client';
import {AuthenticationError, UserInputError} from 'apollo-server-express';
import {extendType, nonNull} from 'nexus';
import UnreachableCaseError from '../utils/UnreachableCaseError';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.nonNull.connectionField('shares', {
      type: 'Share',
      additionalArgs: {
        feedType: nonNull('FeedType'),
      },
      resolve: async (_parent, {feedType, ...args}, ctx) => {
        if (!args.last || args.last < 0) {
          throw new UserInputError('last is less than 0');
        }
        if (!ctx.userId && feedType !== 'Global') {
          throw new AuthenticationError('Not authorized');
        }

        let skip = 0;
        const take = args.last + 1;

        if (args.before) {
          throw new UserInputError('before arg not supported');
        }

        let nodes: Share[];
        switch (feedType) {
          case 'User':
            nodes = await userFeedShares(
              ctx.prismaClient,
              ctx.userId!,
              take,
              skip,
            );
            break;
          case 'Global':
            nodes = await globalFeedShares(ctx.prismaClient, take, skip);
            break;
          case 'Personal':
            nodes = await personalFeedShares(
              ctx.prismaClient,
              true,
              ctx.userId!,
              take,
              skip,
            );
            break;
          default:
            throw new UnreachableCaseError(feedType);
        }

        const hasExtraNode = nodes.length === take;

        // Remove the extra node from the results
        if (hasExtraNode) {
          nodes.pop();
        }

        // cut off list before the cursor
        if (args.after) {
          let found = false;
          nodes = nodes.filter((n) => {
            found = found || n.id === args.after;
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

function globalFeedShares(
  prismaClient: PrismaClient,
  take: number,
  skip: number,
): Promise<Share[]> {
  return prismaClient.share.findMany({
    take,
    skip,
    where: {
      hideFromGlobalFeed: false,
    },
    orderBy: {
      createdAt: 'desc',
    },
  });
}

function userFeedShares(
  prismaClient: PrismaClient,
  userId: string,
  take: number,
  skip: number,
): Promise<Share[]> {
  return prismaClient.share.findMany({
    take,
    skip,
    where: {
      authorId: userId,
    },
    orderBy: {
      createdAt: 'desc',
    },
  });
}

export async function personalFeedShares(
  prismaClient: PrismaClient,
  includeMyShares: boolean,
  userId: string,
  take: number,
  skip: number,
): Promise<Share[]> {
  return prismaClient.$queryRaw(
    `SELECT s.* FROM "Share" s
     LEFT JOIN "AddedToPersonalFeed" a ON a."shareId" = s."id"
       WHERE 
         "authorId" = ANY(SELECT UNNEST(following) FROM "TwitterAccount" WHERE "userId" = $1)
         OR "id" IN (SELECT "shareId" FROM "AddedToPersonalFeed" WHERE "userId" = $1)
         ${includeMyShares ? `OR "authorId" = $1` : ''}
     ORDER BY COALESCE(a."createdAt", s."createdAt") DESC
     LIMIT $2 OFFSET $3;
    `,
    userId,
    take,
    skip,
  );
}
