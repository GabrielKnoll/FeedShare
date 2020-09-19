import {schema} from 'nexus';
import prismaClient from './prismaClient';
import {stringArg} from 'nexus/components/schema';
import token from './utils/token';

schema.mutationType({
  definition(t) {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg({
          required: false,
        }),
      },
      resolve: async (_, args, ctx) => {
        const {userId} = token(ctx);
        if (!userId) {
          throw new Error('No user');
        }

        return prismaClient.share.create({
          data: {
            episode: {
              connect: {
                id: '1',
              },
            },
            message: args.message,
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
