import {extendType, stringArg} from '@nexus/schema';
import {twitterProfile} from '../utils/twitterApi';

export default extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('upsertUser', {
      type: 'User',
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
        {prismaClient},
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
          TwitterAccount: {
            connect: {
              id: twitterId,
            },
            create: {
              id: twitterId,
              secret: twitterTokenSecret,
              token: twitterToken,
            },
          },
        };

        const user = prismaClient.user.upsert({
          create: payload,
          update: payload,
          where: {
            twitterAccountId: twitterId,
          },
        });

        return user;
      },
    });
  },
});
