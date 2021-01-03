import {Prisma, Share} from '@prisma/client';
import * as OneSignal from 'onesignal-node';
import {userFollowers} from '../graphql/models/User';
import prismaClient from './prismaClient';

const client = new OneSignal.Client(
  process.env.ONESIGNAL_APP_ID,
  process.env.ONESIGNAL_API_KEY,
);

const middleware: Prisma.Middleware<Share> = async (params, next) => {
  const result = await next(params);

  if (params.model === 'Share' && params.action === 'create') {
    const ids = await userFollowers(prismaClient, result.authorId);

    if (ids.length > 0) {
      const res = await prismaClient.share.findUnique({
        where: {
          id: result.id,
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

      await Promise.all(
        ids.map((id) =>
          client.createNotification({
            included_segments: ['All'],
            headings: {
              en: `${res?.author.displayName} shared an episode:`,
            },
            subtitle: {
              en: `${res?.episode.title} – ${res?.episode?.podcast.title}`,
            },
            contents: {
              en: result.message,
            },
            external_id: id,
            ios_badgeType: 'Increase',
            ios_badgeCount: 1,
          }),
        ),
      ).catch(console.error);
    }
  }

  return result;
};

export default middleware;
