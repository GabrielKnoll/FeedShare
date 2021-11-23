import {objectType} from 'nexus';
import {PrismaClient, User} from '@prisma/client';
import imageField from '../utils/imageField';
import Node from './Node';
import {User as U} from 'nexus-prisma';

export default objectType({
  name: 'User',
  definition(t) {
    t.implements(Node);
    imageField(t, 'profilePicture');

    t.field(U.handle);
    t.field(U.displayName);
    t.nonNull.countableConnection('followers', {
      type: 'User',
      totalCount: async (source) => (source as any)._totalCount,
      async resolve(root, {first, after, before}, {prismaClient}) {
        if (after || before) {
          throw new Error('Pagination not implemented');
        }
        const userId = (root as User).id;
        const followers = await userFollowers(prismaClient, userId);
        const totalCount = followers.length;
        const user = followers.slice(0, first ?? undefined);

        return {
          pageInfo: {
            hasNextPage: user.length < totalCount,
            hasPreviousPage: false, // pagination not implemented
          },
          edges: user.map((user) => ({cursor: user.id, node: user})),
          _totalCount: totalCount,
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
        const totalCount = following.length;

        const user = following.slice(0, first ?? undefined);
        return {
          pageInfo: {
            hasNextPage: user.length < totalCount,
            hasPreviousPage: false, // pagination not implemented
          },
          edges: user.map((user) => ({cursor: user.id, node: user})),
          _totalCount: totalCount,
        };
      },
    });
  },
});

export async function userFollowing(
  prismaClient: PrismaClient,
  userId: string,
): Promise<User[]> {
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

  const peopleUserFollows = user?.twitterAccount?.following;

  if (!peopleUserFollows || peopleUserFollows.length === 0) {
    return [];
  }

  const following = await prismaClient.user.findMany({
    where: {
      twitterAccount: {
        id: {
          in: peopleUserFollows,
        },
      },
    },
  });

  return following;
}

export async function userFollowers(
  prismaClient: PrismaClient,
  userId: string,
): Promise<User[]> {
  const user = await prismaClient.user.findUnique({
    where: {
      id: userId,
    },
    include: {
      twitterAccount: true,
    },
  });

  const twitterId = user?.twitterAccount?.id;
  if (!twitterId) {
    return [];
  }

  const users = await prismaClient.user.findMany({
    where: {
      twitterAccount: {
        following: {
          has: twitterId,
        },
      },
    },
  });

  return users;
}
