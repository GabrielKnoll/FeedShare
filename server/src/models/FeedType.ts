import {enumType} from 'nexus';

const members = ['User', 'Personal', 'Global'] as const;

export type FeedTypeEnum = typeof members[number];

export default enumType({
  name: 'FeedType',
  members,
});
