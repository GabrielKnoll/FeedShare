import {extendType, stringArg} from '@nexus/schema';
import {getViewer} from '../models/Viewer';
import {twitterFollowing, twitterProfile} from '../utils/twitterApi';
import {generateToken} from '../utils/context';
import feedToken from '../utils/feedToken';

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
        const [
          {
            data: {
              name: displayName,
              profile_image_url: profilePicture,
              username: handle,
            },
          },
          following,
          twitterAccount,
        ] = await Promise.all([
          twitterProfile(twitterId, twitterToken, twitterTokenSecret),
          twitterFollowing(twitterToken, twitterTokenSecret),
          ctx.prismaClient.twitterAccount.findOne({
            where: {
              id: twitterId,
            },
          }),
        ]);

        const payload = {
          handle,
          displayName,
          profilePicture,
        };

        const twitterPayload = {
          id: twitterId,
          secret: twitterTokenSecret,
          token: twitterToken,
          following,
        };

        const user = twitterAccount
          ? await ctx.prismaClient.user.update({
              data: {
                ...payload,
                twitterAccount: {
                  update: twitterPayload,
                },
              },
              where: {
                id: twitterAccount.userId,
              },
            })
          : await ctx.prismaClient.user.create({
              data: {
                ...payload,
                feedToken: feedToken(),
                twitterAccount: {
                  create: twitterPayload,
                },
              },
            });

        return getViewer(user, {
          ...ctx,
          token: generateToken({
            userId: user.id,
          }),
        });
      },
    });
  },
});
