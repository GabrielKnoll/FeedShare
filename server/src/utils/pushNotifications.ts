import {Prisma, Share} from '@prisma/client';
import * as OneSignal from 'onesignal-node';
import prismaClient from './prismaClient';
import env from './env';

const client = new OneSignal.Client(
  env.ONESIGNAL_APP_ID,
  env.ONESIGNAL_API_KEY,
);

const middleware: Prisma.Middleware<Share> = async (params, next) => {
  const result = await next(params);

  if (params.model === 'Share' && params.action === 'create') {
    const ids = await prismaClient.$queryRaw<
      Array<{
        id: string;
      }>
    >(`SELECT "User"."id"
      FROM "TwitterAccount"
      LEFT OUTER JOIN "User"
        ON "TwitterAccount"."userId"="User"."id"
      WHERE (SELECT id FROM "TwitterAccount" WHERE "userId"='${result.authorId}')=ANY("following");`);

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
        ids.map(({id}) =>
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
