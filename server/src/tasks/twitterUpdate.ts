import prismaClient from '../utils/prismaClient';
import {twitterFollowing, twitterProfile} from '../utils/twitterApi';

export default async function ({userId}: {userId?: string}) {
  if (!userId) {
    throw new Error(`Missing userId in payload.`);
  }
  const twitterAccount = await prismaClient.twitterAccount.findUnique({
    where: {
      userId,
    },
  });
  if (!twitterAccount || !twitterAccount.token || !twitterAccount.secret) {
    throw new Error(`Could not find Twitter account for user ID ${userId}`);
  }

  const [{data: profile}, following] = await Promise.all([
    twitterProfile(
      twitterAccount.id,
      twitterAccount.token,
      twitterAccount.secret,
    ),
    twitterFollowing(twitterAccount.token, twitterAccount.secret),
  ]);

  await prismaClient.twitterAccount.update({
    data: {
      following,
    },
    where: {
      id: twitterAccount.id,
    },
  });

  await prismaClient.user.update({
    data: {
      displayName: profile.name,
      handle: profile.username,
      profilePicture: profile.profile_image_url,
    },
    where: {
      id: userId,
    },
  });
}
