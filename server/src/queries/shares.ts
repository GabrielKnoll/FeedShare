import {objectType} from 'nexus/components/schema';
import {schema} from 'nexus';
import {findManyCursor} from '../utils/findManyCursor';
import {ConnectionArgs, PageInfo} from '../utils/connection';

schema.extendType({
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
      resolve: async (_parent, args, {db}) =>
        findManyCursor<any>(
          (_args) =>
            db.share.findMany({
              ..._args,
              select: {
                id: true,
              },
              orderBy: {
                createdAt: 'desc',
              },
            }),
          args,
        ),
    });
  },
});
