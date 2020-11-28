import {enumType} from '@nexus/schema';

const members = ['Friends', 'Personal', 'Global'] as const;

export type FeedTypeEnum = typeof members[number];

export default enumType({
  name: 'FeedType',
  members,
});
