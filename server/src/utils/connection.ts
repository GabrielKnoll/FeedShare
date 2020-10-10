import {objectType, intArg, stringArg} from '@nexus/schema';

export const PageInfo = objectType({
  name: 'PageInfo',
  definition(t) {
    t.string('startCursor', {
      nullable: true,
    });
    t.string('endCursor', {
      nullable: true,
    });
    t.boolean('hasPreviousPage');
    t.boolean('hasNextPage');
  },
});

export const ConnectionArgs = {
  last: intArg({
    required: true,
  }),
  after: stringArg({
    required: false,
  }),
  before: stringArg({
    required: false,
  }),
};
