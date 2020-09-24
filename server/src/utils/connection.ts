import {objectType, intArg, stringArg} from 'nexus/components/schema';

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
  first: intArg({
    required: true,
  }),
  after: stringArg({
    required: false,
  }),
  before: stringArg({
    required: false,
  }),
};
