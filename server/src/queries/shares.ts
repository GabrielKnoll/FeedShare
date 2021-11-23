import {PrismaClient, Share, User} from '@prisma/client';
import {empty, sqltag} from '@prisma/client/runtime';
import {UserInputError} from 'apollo-server-express';
import {extendType} from 'nexus';

export const globalFeed = extendType({
  type: 'Query',
  definition: (t) => {
    t.nonNull.connectionField('globalFeed', {
      type: 'Share',
      description: 'Shares on the global feed',
      resolve: async (_parent, args, ctx) => {
        const {take, skip, cursor} = argsValidation(args);

        const nodes = await ctx.prismaClient.share.findMany({
          take,
          skip,
          cursor,
          where: {
            hideFromGlobalFeed: false,
          },
          orderBy: {
            createdAt: 'desc',
          },
        });

        return shareConnection(nodes, take, cursor);
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
        const {take, skip, cursor} = argsValidation(args);

        const nodes = await personalFeedShares(
          ctx.prismaClient,
          true,
          ctx.userId!,
          take,
          skip,
          cursor,
        );

        return shareConnection(nodes, take, cursor);
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
        const {take, skip, cursor} = argsValidation(args);
        const userID = (user as User).id;

        const nodes = await ctx.prismaClient.share.findMany({
          where: {
            authorId: userID,
            hideFromGlobalFeed: ctx.userId != userID ? false : undefined,
          },
          take,
          skip,
          cursor,
          orderBy: {
            createdAt: 'desc',
          },
        });

        return shareConnection(nodes, take, cursor);
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
  if (args.after) {
    throw new UserInputError('after arg not supported');
  }
  if (args.last) {
    throw new UserInputError('last arg not supported');
  }
  if ((args.first ?? 0) < 0) {
    throw new UserInputError('first is less than 0');
  }

  const first = args.first ?? 40;
  const before = args.before;

  return {
    take: first + 1, // take one more, so we know if more before that
    skip: before ? 1 : 0,
    cursor: before
      ? {
          id: before,
        }
      : undefined,
  };
}

function shareConnection(nodes: Share[], take: number, cursor?: {id: string}) {
  let hasPreviousPage = false;
  if (nodes.length === take) {
    // we have one too many
    nodes.pop();
    hasPreviousPage = true;
  }

  return {
    pageInfo: {
      hasPreviousPage,
      hasNextPage: cursor?.id != null,
      startCursor: nodes.length > 0 ? nodes[0].id : undefined,
      endCursor: nodes.length > 0 ? nodes[nodes.length - 1].id : undefined,
    },
    edges: nodes.map((node) => ({cursor: node.id, node})),
  };
}

export async function personalFeedShares(
  prismaClient: PrismaClient,
  includeMyShares: boolean,
  userId: string,
  take: number,
  skip: number,
  cursor?: {id: string},
): Promise<Share[]> {
  return prismaClient.$queryRaw`
    SELECT s.* FROM "Share" s
    LEFT JOIN "AddedToPersonalFeed" a ON a."shareId" = s."id"
      WHERE (
        "authorId" = ANY(
          -- Twitter follows on platform
              SELECT "userId" FROM "TwitterAccount" WHERE "id" = ANY(
                -- Twitter followers
                SELECT UNNEST(following) FROM "TwitterAccount" WHERE "userId" = ${userId}
              )
            )
            -- Added to personal feed
            OR "id" IN (SELECT "shareId" FROM "AddedToPersonalFeed" WHERE "userId" = ${userId})
            -- Share from user themselves
            ${includeMyShares ? sqltag`OR "authorId" = ${userId}` : empty}
      )
      -- is before cursor
      ${
        cursor
          ? sqltag`AND (s."createdAt" <= (SELECT "createdAt" FROM "Share" WHERE "id" = ${cursor.id}))`
          : empty
      }
      ORDER BY COALESCE(a."createdAt", s."createdAt") DESC
      LIMIT ${take} OFFSET ${skip};
`;
}
