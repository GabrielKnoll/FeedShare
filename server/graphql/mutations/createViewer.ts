import {extendType, nonNull, stringArg} from 'nexus';
import {twitterFollowing, twitterProfile} from '../../utils/twitterApi';
import feedToken from '../../utils/feedToken';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createViewer', {
      type: 'Viewer',
      args: {
        twitterId: nonNull(stringArg()),
        twitterToken: nonNull(stringArg()),
        twitterTokenSecret: nonNull(stringArg()),
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
          ctx.prismaClient.twitterAccount.findUnique({
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

        return {user};
      },
    });
  },
});
