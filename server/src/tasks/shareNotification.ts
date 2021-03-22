import prismaClient from '../utils/prismaClient';
import {userFollowers} from '../models/User';
import {sendPush} from '../utils/oneSignal';

export default async function ({shareId}: {shareId: string}) {
  if (!shareId) {
    throw new Error(`Missing shareId in payload.`);
  }
  const share = await prismaClient.share.findUnique({
    where: {
      id: shareId,
    },
    include: {
      author: true,
      episode: {
        include: {
          podcast: true,
        },
      },
    },
  });
  if (!share) {
    throw new Error(`Could not find share ${shareId}`);
  }

  return await sendPush(
    (await userFollowers(prismaClient, share.authorId)).map(({id}) => id),
    {
      title: `${share?.author.displayName} shared an episode:`,
      subtitle: `${share?.episode.title} – ${share?.episode?.podcast.title}`,
      body: share.message ?? '',
      image: share.episode.artwork ?? share.episode.podcast.artwork,
    },
    true,
  );
}
