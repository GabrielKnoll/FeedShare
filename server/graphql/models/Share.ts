import {objectType, nonNull} from 'nexus';
import {Prisma, Share} from '@prisma/client';
import {FeedTypeEnum} from './FeedType';
import {Context} from '../../utils/context';
import Node from './Node';
import {userFollowing} from './User';
import UnreachableCaseError from '../../utils/UnreachableCaseError';
import {AddArgumentsAsVariables} from 'apollo-server-micro';

export default objectType({
  name: 'Share',
  definition(t) {
    t.implements(Node);
    t.model.author();
    t.model.message();
    t.model.createdAt();
    t.model.episode();
    t.field('isInFeed', {
      args: {
        feedType: nonNull('FeedType'),
      },
      type: 'Boolean',
      resolve: async (
        {authorId, hideFromGlobalFeed, id}: Partial<Share>,
        {feedType},
        {userId, prismaClient},
      ) => {
        switch (feedType) {
          case 'User':
            return authorId === userId;
          case 'Personal':
            if (authorId === userId) {
              return true;
            }
            const addedToPersonalFeed = await prismaClient.addedToPersonalFeed.findUnique(
              {
                where: {
                  shareId_userId: {
                    userId: userId!,
                    shareId: id!,
                  },
                },
              },
            );
            if (addedToPersonalFeed != null) {
              return true;
            }

            const following = await userFollowing(prismaClient, userId!);
            const share = await prismaClient.share.findUnique({
              where: {
                id,
              },
              include: {
                author: {
                  include: {
                    twitterAccount: true,
                  },
                },
              },
            });

            return following.includes(share?.author.twitterAccount?.id ?? '');
          case 'Global':
            return !hideFromGlobalFeed;
          default:
            throw new UnreachableCaseError(feedType);
        }
      },
    });
  },
});

export async function shareWhere(
  {userId, prismaClient}: Context,
  feedType: FeedTypeEnum,
): Promise<Prisma.ShareWhereInput | undefined> {
  switch (feedType) {
    case 'User':
      return {
        authorId: userId,
      };
    case 'Personal':
      const following = await userFollowing(prismaClient, userId!);

      return {
        OR: [
          {
            AddedToPersonalFeed: {
              some: {
                userId,
              },
            },
          },
          {
            author: {
              OR: [
                {
                  id: userId,
                },
                {
                  twitterAccount: {
                    id: {
                      in: following,
                    },
                  },
                },
              ],
            },
          },
        ],
      };
    case 'Global':
      return {
        hideFromGlobalFeed: false,
      };
    default:
      throw new UnreachableCaseError(feedType);
  }
}
