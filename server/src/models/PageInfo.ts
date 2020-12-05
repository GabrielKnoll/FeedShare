import {objectType} from '@nexus/schema';

export default objectType({
  name: 'PageInfo',
  definition(t) {
    t.string('startCursor');
    t.string('endCursor');
    t.boolean('hasPreviousPage');
    t.boolean('hasNextPage');
  },
});
