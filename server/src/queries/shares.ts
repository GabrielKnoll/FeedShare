import {objectType, extendType} from '@nexus/schema';
import {findManyCursor} from '../utils/findManyCursor';
import {ConnectionArgs, PageInfo} from '../utils/connection';
import {Share} from '@prisma/client';

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
        findManyCursor<Share>(
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
