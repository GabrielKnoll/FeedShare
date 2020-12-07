import {extendType, stringArg, idArg, nonNull} from '@nexus/schema';
import {parseId} from '../queries/node';
import requireAuthorization from '../utils/requireAuthorization';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg(),
        episodeId: nonNull(idArg()),
      },
      ...requireAuthorization,
      resolve: async (_, {message, episodeId}, {prismaClient, userId}) =>
        prismaClient.share.create({
          data: {
            episode: {
              connect: {
                id: parseId(episodeId).key,
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
