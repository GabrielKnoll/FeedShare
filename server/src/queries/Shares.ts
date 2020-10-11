import {objectType, extendType} from '@nexus/schema';
import {findManyCursor} from '../utils/findManyCursor';
import {ConnectionArgs, PageInfo} from '../utils/connection';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('shares', {
      type: objectType({
        name: 'ShareConnection',
        definition(t) {
          t.field('pageInfo', {
            type: PageInfo,
          });
          t.list.field('edges', {
            type: objectType({
              name: 'ShareEdge',
              definition(t) {
                t.string('cursor');
                t.field('node', {type: 'Share'});
              },
            }),
          });
        },
      }),
      args: ConnectionArgs,
      nullable: false,
      resolve: async (_parent, args, {prismaClient}) =>
        findManyCursor<any>(
          (_args) =>
            prismaClient.share.findMany({
              ..._args,
              orderBy: {
                createdAt: 'desc',
              },
            }),
          args,
        ),
    });
  },
});
