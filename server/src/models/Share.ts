import {objectType} from 'nexus';
import {Share} from '@prisma/client';
import Node from './Node';
import {userFollowing} from './User';
import {Share as S} from 'nexus-prisma';

export default objectType({
  name: 'Share',
  definition(t) {
    t.implements(Node);
    t.field(S.author);
    t.field(S.message);
    t.field(S.createdAt);
    t.field(S.episode);
    t.field('isInGlobalFeed', {
      type: 'Boolean',
      resolve: async ({hideFromGlobalFeed}: Partial<Share>) => {
        return !hideFromGlobalFeed;
      },
    });
    t.field('isInPersonalFeed', {
      type: 'Boolean',
      resolve: async (
        {authorId, id}: Partial<Share>,
        _,
        {userId, prismaClient},
      ) => {
        if (authorId === userId) {
          return true;
        }
        const addedToPersonalFeed =
          await prismaClient.addedToPersonalFeed.findUnique({
            where: {
              shareId_userId: {
                userId: userId!,
                shareId: id!,
              },
            },
          });
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
      },
    });
  },
});
