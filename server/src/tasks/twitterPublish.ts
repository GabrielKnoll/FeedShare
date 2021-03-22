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

  let status = `${env.BASE_URL}/s/${share.id}`;
  let availableLength = () => 280 - status.length;

  let message = share.message?.trim();
  if (message) {
    status = `\n${status}`;

    if (message.length > availableLength()) {
      status = `…${status}`;
      const spaceIndex = message.substr(0, availableLength()).lastIndexOf(' ');
      message = message.substr(
        0,
        spaceIndex > -1 ? spaceIndex : availableLength(),
      );
    }
    status = `${message}${status}`;
  }
  return await sendTweet(token, secret, status);
}
