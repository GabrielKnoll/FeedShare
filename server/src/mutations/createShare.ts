import {stringArg} from 'nexus/components/schema';
import {schema} from 'nexus';
import parseToken from '../utils/parseToken';

schema.extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg({
          required: false,
        }),
        url: stringArg({
          required: true,
        }),
      },
      resolve: async (_, args, {db, token}) => {
        const {userId} = parseToken(token);
        if (!userId) {
          throw new Error('No user');
        }

        return db.share.create({
          data: {
            podcast: {
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
