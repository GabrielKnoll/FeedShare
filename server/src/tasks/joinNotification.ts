import prismaClient from '../utils/prismaClient';
import {userFollowers, userFollowing} from '../models/User';
import {sendPush} from '../utils/oneSignal';

const task = async ({userId}: {userId?: string}) => {
  if (!userId) {
    throw new Error(`Missing userId in payload.`);
  }
  const user = await prismaClient.user.findUnique({
    where: {
      id: userId,
    },
  });
  if (!user) {
    throw new Error(`Could not find user ${userId}`);
  }

  const followers = new Set(
    (await userFollowers(prismaClient, userId)).map(({id}) => id),
  );
  const following = new Set(
    (await userFollowing(prismaClient, userId)).map(({id}) => id),
  );
  const mutualFollowing = new Set<string>();

  followers.forEach((follower) => {
    if (following.has(follower)) {
      mutualFollowing.add(follower);
      followers.delete(follower);
      following.delete(follower);
    }
  });

  const title = `${user.displayName} just joined`;

  const mutualFollows = await sendPush(Array.from(mutualFollowing), {
    title,
    body: 'You will now see episodes recommended by each other.',
  });

  const pushFollowers = await sendPush(Array.from(followers), {
    title,
    body: 'You will now see episodes they share in your recommendations.',
  });

  const pushFollowing = await sendPush(Array.from(following), {
    title,
    body: 'They will see episodes you share in their recommendations.',
  });

  return {pushFollowers, pushFollowing, mutualFollows};
};

export default task;
