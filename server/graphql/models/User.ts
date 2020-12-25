import {intArg, objectType} from '@nexus/schema';
import {User} from '@prisma/client';
import imageField from '../../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'User',
  definition(t) {
    t.implements(Node);

    t.model.handle();
    t.model.displayName();
    t.list.field('following', {
      type: 'User',
      args: {
        limit: intArg(),
      },
      resolve: async (root: Partial<User>, {limit}, {prismaClient}) => {
        const user = await prismaClient.user.findUnique({
          where: {
            id: root.id,
          },
          include: {
            twitterAccount: {
              select: {
                following: true,
              },
            },
          },
        });

        return prismaClient.user.findMany({
          where: {
            twitterAccount: {
              id: {
                in: user?.twitterAccount?.following,
              },
            },
          },
          take: limit ?? 10,
        });
      },
    });
    imageField(t, 'profilePicture');
  },
});
