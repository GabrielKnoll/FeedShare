import {extendType, stringArg} from '@nexus/schema';
import {getViewer} from '../models/Viewer';
import {twitterProfile} from '../utils/twitterApi';
import {generateToken} from '../utils/context';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createViewer', {
      type: 'Viewer',
      args: {
        twitterId: stringArg({
          required: true,
        }),
        twitterToken: stringArg({
          required: true,
        }),
        twitterTokenSecret: stringArg({
          required: true,
        }),
      },
      resolve: async (
        _,
        {twitterId, twitterToken, twitterTokenSecret},
        ctx,
      ) => {
        const {
          data: {
            name: displayName,
            profile_image_url: profilePicture,
            username: handle,
          },
        } = await twitterProfile(twitterId, twitterToken, twitterTokenSecret);

        const payload = {
          handle,
          displayName,
          profilePicture,
        };

        const user = await ctx.prismaClient.user.upsert({
          create: {
            ...payload,
            TwitterAccount: {
              create: {
                id: twitterId,
                secret: twitterTokenSecret,
                token: twitterToken,
              },
            },
          },
          update: payload,
          where: {
            twitterAccountId: twitterId,
          },
        });

        const token = generateToken({
          userId: user.id,
        });

        return getViewer(user, {...ctx, token});
      },
    });
  },
});
