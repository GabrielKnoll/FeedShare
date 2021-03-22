import minimist from 'minimist';
import {taskList} from '.';
import {scheduleTask} from './index';

const {payload, type} = minimist(process.argv.slice(2));

if (!type || !(type in taskList)) {
  throw new Error('Supply type using --type $type');
}
scheduleTask(type, payload ? JSON.parse(payload) : undefined).then(() =>
  process.exit(0),
);
