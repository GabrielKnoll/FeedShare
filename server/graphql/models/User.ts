import {objectType} from 'nexus';
import {PrismaClient, User} from '@prisma/client';
import imageField from '../../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'User',
  definition(t) {
    t.implements(Node);
    imageField(t, 'profilePicture');

    t.model.handle();
    t.model.displayName();
    t.nonNull.countableConnection('followers', {
      type: 'User',
      totalCount: async (source) => (source as any)._totalCount,
      async resolve(root, {first, after, before}, {prismaClient}) {
        if (after || before) {
          throw new Error('Pagination not implemented');
        }
        const userId = (root as User).id;
        const followers = await userFollowers(prismaClient, userId);

        const nodes = await prismaClient.user.findMany({
          where: {
            id: {
              in: followers,
            },
          },
          take: first ?? 10,
        });

        return {
          pageInfo: {
            hasNextPage: nodes.length < followers.length,
            hasPreviousPage: false, // pagination not implemented
          },
          edges: nodes.map((user) => ({cursor: user.id, node: user})),
          _totalCount: followers.length,
        };
      },
    });

    t.nonNull.countableConnection('following', {
      type: 'User',
      totalCount: async (source) => (source as any)._totalCount,
      async resolve(root, {first, after, before}, {prismaClient}) {
        if (after || before) {
          throw new Error('Pagination not implemented');
        }
        const userId = (root as User).id;
        const following = await userFollowing(prismaClient, userId);
        const where = {
          twitterAccount: {
            id: {
              in: following,
            },
          },
        };
        const nodes = await prismaClient.user.findMany({
          where,
          take: first ?? 10,
        });

        const totalCount = await prismaClient.user.count({
          where,
        });

        return {
          pageInfo: {
            hasNextPage: nodes.length < totalCount,
            hasPreviousPage: false, // pagination not implemented
          },
          edges: nodes.map((user) => ({cursor: user.id, node: user})),
          _totalCount: totalCount,
        };
      },
    });
  },
});

export async function userFollowing(
  prismaClient: PrismaClient,
  userId: string,
) {
  const user = await prismaClient.user.findUnique({
    where: {
      id: userId,
    },
    include: {
      twitterAccount: {
        select: {
          following: true,
        },
      },
    },
  });

  return user?.twitterAccount?.following ?? [];
}

export async function userFollowers(
  prismaClient: PrismaClient,
  userId: string,
) {
  const user = await prismaClient.$queryRaw<
    Array<{
      id: string;
    }>
  >(`SELECT "User"."id"
      FROM "TwitterAccount"
      LEFT OUTER JOIN "User"
        ON "TwitterAccount"."userId"="User"."id"
      WHERE (SELECT id FROM "TwitterAccount" WHERE "userId"='${userId}')=ANY("following");`);

  return user.map(({id}) => id);
}
