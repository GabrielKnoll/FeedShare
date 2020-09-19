import {schema} from 'nexus';
import prismaClient from './prismaClient';
import {stringArg} from 'nexus/components/schema';

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
        const user = ctx.token?.user;
        if (!user) {
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
                id: user,
              },
            },
          },
        });
      },
    });
  },
});
