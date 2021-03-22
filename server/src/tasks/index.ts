import shareNotification from './shareNotification';
import joinNotification from './joinNotification';
import twitterUpdate from './twitterUpdate';
import twitterPublish from './twitterPublish';
import twitterUpdateAll from './twitterUpdateAll';
import {quickAddJob} from 'graphile-worker';
import {Schedule} from 'graphile-scheduler/dist/upsertSchedule';
import indexUpdate from './indexUpdate';

export const taskList = {
  ShareNotification: shareNotification,
  JoinNotification: joinNotification,
  TwitterPublish: twitterPublish,
  TwitterUpdate: twitterUpdate,
  TwitterUpdateAll: twitterUpdateAll,
  IndexUpdate: indexUpdate,
};

export const schedules: Array<
  Schedule & {taskIdentifier: keyof typeof taskList}
> = [
  {
    name: 'asd',
    pattern: '0 3 * * *', // every night at 3
    timeZone: 'Europe/London',
    taskIdentifier: 'TwitterUpdateAll',
  },
];

type Payload<T extends keyof typeof taskList> = Parameters<
  typeof taskList[T]
>[0];

export const scheduleTask = <T extends keyof typeof taskList>(
  type: T,
  payload: Payload<T>,
) => quickAddJob({}, type, payload);
