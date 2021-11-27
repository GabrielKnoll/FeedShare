import env from '../utils/env';
import prismaClient from '../utils/prismaClient';
import {sendTweet} from '../utils/twitterApi';

export default async function ({shareId}: {shareId?: string}) {
  const share = await prismaClient.share.findUnique({
    where: {
      id: shareId,
    },
    include: {
      author: {
        include: {
          twitterAccount: true,
        },
      },
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

  const {token, secret} = share.author.twitterAccount ?? {};
  if (!token || !secret) {
    throw new Error(`Could not find Twitter account for ${shareId}`);
  }

  const status = [`${env.BASE_URL}/s/${share.id}`];
  const message = share.message?.trim();
  const maxLength = 280;

  if (message && message.length > 0) {
    status.unshift(message, '\n\n');
    if (status.join().length > maxLength) {
      status.splice(1, 0, '…');
    }
    while (status.join().length > maxLength) {
      const m = status[0].split(' ');
      m.pop();
      status[0] = m.join(' ');
    }
  }

  return await sendTweet(token, secret, status.join());
}
