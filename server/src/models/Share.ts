import {objectType, nonNull} from 'nexus';
import {Share} from '@prisma/client';
import Node from './Node';
import {userFollowing} from './User';
import UnreachableCaseError from '../utils/UnreachableCaseError';

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
            });

            return following.map(({id}) => id).includes(share?.authorId ?? '');
          case 'Global':
            return !hideFromGlobalFeed;
          default:
            throw new UnreachableCaseError(feedType);
        }
      },
    });
  },
});
