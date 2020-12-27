import {objectType} from '@nexus/schema';
import {Prisma} from '@prisma/client';
import {FeedTypeEnum} from './FeedType';
import {Context} from '../../utils/context';
import Node from './Node';

export default objectType({
  name: 'Share',
  definition(t) {
    t.implements(Node);

    t.model.author();
    t.model.message();
    t.model.createdAt();
    t.model.episode();
  },
});

export async function shareWhere(
  {userId, prismaClient}: Context,
  feedType: FeedTypeEnum | null | undefined,
): Promise<Prisma.ShareWhereInput | undefined> {
  if (feedType === 'Personal') {
    return {
      authorId: userId,
    };
  } else if (feedType === 'Friends') {
    const twitterAccount = await prismaClient.twitterAccount.findUnique({
      where: {userId},
    });

    return {
      hideFromGlobalFeed: false,
      author: {
        twitterAccount: {
          id: {
            in: twitterAccount?.following,
          },
        },
      },
    };
  }
}
