import {sub} from 'date-fns';
import {scheduleTask} from '.';
import prismaClient from '../utils/prismaClient';

export default async function (): Promise<void> {
  const twitterAccounts = await prismaClient.twitterAccount.findMany({
    where: {
      updatedAt: {
        lt: sub(new Date(), {hours: 20}),
      },
    },
    select: {
      userId: true,
    },
  });

  await Promise.all(
    twitterAccounts.map(({userId}) => scheduleTask('TwitterUpdate', {userId})),
  );
}
