import shareNotification from './shareNotification';
import joinNotification from './joinNotification';
import twitterUpdate from './twitterUpdate';
import twitterPublish from './twitterPublish';
import twitterUpdateAll from './twitterUpdateAll';
import {quickAddJob, run, WorkerEventMap} from 'graphile-worker';
import indexUpdate from './indexUpdate';
import env from '../utils/env';
import {EventEmitter} from 'events';
import prismaClient from '../utils/prismaClient';

const taskList = {
  ShareNotification: shareNotification,
  JoinNotification: joinNotification,
  TwitterPublish: twitterPublish,
  TwitterUpdate: twitterUpdate,
  TwitterUpdateAll: twitterUpdateAll,
  IndexUpdate: indexUpdate,
};

type Payload<T extends keyof typeof taskList> = Parameters<
  typeof taskList[T]
>[0];

export const scheduleTask = <T extends keyof typeof taskList>(
  type: T,
  payload: Payload<T>,
) => quickAddJob({}, type, payload);

declare interface WorkerEventEmitter {
  on<T extends keyof WorkerEventMap>(
    event: T,
    listener: (value: WorkerEventMap[T]) => void,
  ): this;
}
class WorkerEventEmitter extends EventEmitter {}

export default async function () {
  await run({
    connectionString: env.DATABASE_URL,
    concurrency: 1,
    taskList: taskList as any,
    crontab: ['0 3 * * * TwitterUpdateAll', '0 4 * * * IndexUpdate'].join('\n'),
    events: new WorkerEventEmitter()
      .on('job:start', async ({job, worker}) => {
        await prismaClient.jobLog.create({
          data: {
            status: 'START',
            workerId: worker.workerId,
            jobId: job.id,
            taskIdentifier: job.task_identifier,
          },
        });
      })
      .on('job:failed', async ({job, error, worker}) => {
        await prismaClient.jobLog.create({
          data: {
            status: 'FAILED',
            workerId: worker.workerId,
            jobId: job.id,
            taskIdentifier: job.task_identifier,
            meta: error.toString(),
          },
        });
      })
      .on('job:success', async ({job, worker}) => {
        await prismaClient.jobLog.create({
          data: {
            status: 'SUCCESS',
            workerId: worker.workerId,
            jobId: job.id,
            taskIdentifier: job.task_identifier,
          },
        });
      }),
  });
}
