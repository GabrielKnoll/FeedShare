import {booleanArg, extendType, stringArg, idArg, nonNull} from 'nexus';
import {UserInputError} from 'apollo-server-express';
import {parseId} from '../queries/node';
import requireAuthorization from '../utils/requireAuthorization';
import shortkey from '../utils/shortkey';
import {scheduleTask} from '../tasks';
import {Prisma} from '.prisma/client';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: nonNull(stringArg()),
        episodeId: nonNull(idArg()),
        shareOnTwitter: booleanArg(),
        hideFromGlobalFeed: booleanArg({
          default: false,
        }),
      },
      ...requireAuthorization,
      resolve: async (
        _,
        {message, episodeId, hideFromGlobalFeed, shareOnTwitter},
        {prismaClient, userId},
      ) => {
        try {
          const result = await prismaClient.share.create({
            data: {
              id: shortkey(10),
              episode: {
                connect: {
                  id: parseId(episodeId).key,
                },
              },
              message: message?.trim(),
              hideFromGlobalFeed: hideFromGlobalFeed ?? false,
              author: {
                connect: {
                  id: userId,
                },
              },
            },
          });

          await scheduleTask('ShareNotification', {shareId: result.id});

          if (shareOnTwitter) {
            await scheduleTask('TwitterPublish', {shareId: result.id});
          }

          return result;
        } catch (e) {
          if (
            e instanceof Prisma.PrismaClientKnownRequestError &&
            e.code === 'P2002'
          ) {
            throw new UserInputError(e.code);
          }
          throw e;
        }
      },
    });
  },
});
