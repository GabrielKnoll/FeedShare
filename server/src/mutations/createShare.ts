import {extendType, stringArg, intArg} from '@nexus/schema';
import requireAuthorization from '../utils/requireAuthorization';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg({
          required: false,
        }),
        episodeId: intArg({
          required: true,
        }),
      },
      ...requireAuthorization,
      resolve: async (_, {message, episodeId}, {prismaClient, userId}) =>
        prismaClient.share.create({
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
        }),
    });
  },
});
