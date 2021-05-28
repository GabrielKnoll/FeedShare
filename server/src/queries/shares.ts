import {PrismaClient, Share, User} from '@prisma/client';
import {UserInputError} from 'apollo-server-express';
import {extendType} from 'nexus';

export const globalFeed = extendType({
  type: 'Query',
  definition: (t) => {
    t.nonNull.connectionField('globalFeed', {
      type: 'Share',
      description: 'Shares on the global feed',
      resolve: async (_parent, args, ctx) => {
        const {take, skip, after} = argsValidation(args);

        const nodes = await ctx.prismaClient.share.findMany({
          take,
          skip,
          where: {
            hideFromGlobalFeed: false,
          },
          orderBy: {
            createdAt: 'desc',
          },
        });

        return shareConnection(nodes, take, skip, after);
      },
    });
  },
});

export const personalFeed = extendType({
  type: 'Viewer',
  definition: (t) => {
    t.nonNull.connectionField('personalFeed', {
      type: 'Share',
      description: 'Personal feed for the viewer',
      resolve: async (_parent, args, ctx) => {
        const {take, skip, after} = argsValidation(args);

        const nodes = await personalFeedShares(
          ctx.prismaClient,
          true,
          ctx.userId!,
          take,
          skip,
        );

        return shareConnection(nodes, take, skip, after);
      },
    });
  },
});

export const userFeed = extendType({
  type: 'User',
  definition: (t) => {
    t.nonNull.connectionField('feed', {
      type: 'Share',
      description:
        'Shares from a user, not including hidden shares for other users than self',
      resolve: async (user, args, ctx) => {
        const {take, skip, after} = argsValidation(args);
        const userID = (user as User).id;

        const nodes = await ctx.prismaClient.share.findMany({
          where: {
            authorId: userID,
            hideFromGlobalFeed: ctx.userId != userID ? false : undefined,
          },
          orderBy: {
            createdAt: 'desc',
          },
        });

        return shareConnection(nodes, take, skip, after);
      },
    });
  },
});

function argsValidation(args: {
  after?: string | null;
  before?: string | null;
  first?: number | null;
  last?: number | null;
}) {
  if (args.before) {
    throw new UserInputError('before arg not supported');
  }
  if ((args.last ?? 0) < 0) {
    throw new UserInputError('last is less than 0');
  }
  const take = (args.last ?? 40) + 1;

  return {
    take,
    skip: 0, // never skipping, because we only allow querying from last
    after: args.after,
  };
}

function shareConnection(
  nodes: Share[],
  take: number,
  skip: number = 0,
  after?: string | null,
) {
  const hasExtraNode = nodes.length === take;

  // Remove the extra node from the results
  if (hasExtraNode) {
    nodes.pop();
  }

  // cut off list before the cursor
  if (after) {
    let found = false;
    nodes = nodes.filter((n) => {
      found = found || n.id === after;
      return !found;
    });
  }

  nodes = nodes.reverse();

  // Get the start and end cursors
  const startCursor = nodes.length > 0 ? nodes[0].id : undefined;
  const endCursor = nodes.length > 0 ? nodes[nodes.length - 1].id : undefined;
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
}

export async function personalFeedShares(
  prismaClient: PrismaClient,
  includeMyShares: boolean,
  userId: string,
  take: number,
  skip: number = 0,
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
