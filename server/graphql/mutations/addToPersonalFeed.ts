import {extendType, idArg, nonNull} from 'nexus';
import {parseId} from '../queries/node';
import requireAuthorization from '../../utils/requireAuthorization';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('addToPersonalFeed', {
      type: 'Share',
      args: {
        shareId: nonNull(idArg()),
      },
      ...requireAuthorization,
      resolve: async (_, {shareId}, {prismaClient, userId}) => {
        const {key} = parseId(shareId);

        const {share} = await prismaClient.addedToPersonalFeed.upsert({
          create: {
            share: {
              connect: {
                id: key,
              },
            },
            user: {
              connect: {
                id: userId,
              },
            },
          },
          update: {},
          where: {
            shareId_userId: {
              shareId: key,
              userId: userId!,
            },
          },
          include: {
            share: true,
          },
        });

        return share;
      },
    });
  },
});
