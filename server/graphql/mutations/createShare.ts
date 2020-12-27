import {booleanArg, extendType, stringArg, idArg, nonNull} from 'nexus';
import {UserInputError} from 'apollo-server-micro';
import {parseId} from '../queries/node';
import requireAuthorization from '../../utils/requireAuthorization';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg(),
        episodeId: nonNull(idArg()),
        shareOnTwitter: booleanArg(),
        hideFromGlobalFeed: booleanArg({
          default: false,
        }),
      },
      ...requireAuthorization,
      resolve: async (
        _,
        {message, episodeId, hideFromGlobalFeed},
        {prismaClient, userId},
      ) => {
        try {
          const result = await prismaClient.share.create({
            data: {
              episode: {
                connect: {
                  id: parseId(episodeId).key,
                },
              },
              message,
              hideFromGlobalFeed: hideFromGlobalFeed ?? false,
              author: {
                connect: {
                  id: userId,
                },
              },
            },
          });
          return result;
        } catch (e) {
          if (e.code === 'P2002') {
            throw new UserInputError('P2002');
          }
          throw e;
        }
      },
    });
  },
});
