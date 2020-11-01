import {extendType, stringArg} from '@nexus/schema';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg({
          required: false,
        }),
        episodeId: stringArg({
          required: true,
        }),
      },
      resolve: async (_, {message, episodeId}, {prismaClient, userId}) => {
        if (!userId) {
          throw new Error('No user');
        }

        return prismaClient.share.create({
          data: {
            episode: {
              connect: {
                id: episodeId,
              },
            },
            message: message,
            author: {
              connect: {
                id: userId,
              },
            },
          },
        });
      },
    });
  },
});
