import {objectType} from '@nexus/schema';
import {ShareWhereInput} from '@prisma/client';
import {FeedTypeEnum} from '../models/FeedType';
import {Context} from '../utils/context';

export default objectType({
  name: 'Share',
  definition(t) {
    t.model.id();
    t.model.author();
    t.model.message();
    t.model.createdAt();
    t.model.episode();
  },
});

export async function shareWhere(
  {userId, prismaClient}: Context,
  feedType: FeedTypeEnum | null | undefined,
): Promise<ShareWhereInput | undefined> {
  if (feedType === 'Personal') {
    return {
      authorId: userId,
    };
  } else if (feedType === 'Friends') {
    const twitterAccount = await prismaClient.twitterAccount.findOne({
      where: {userId},
    });

    return {
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
