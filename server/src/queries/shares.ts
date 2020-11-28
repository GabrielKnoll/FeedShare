import {objectType, extendType} from '@nexus/schema';
import FeedType from '../models/FeedType';
import {findManyCursor} from '../utils/findManyCursor';
import {ConnectionArgs, PageInfo} from '../utils/connection';
import {Share} from '@prisma/client';
import requireAuthorization from '../utils/requireAuthorization';
import {shareWhere} from '../models/Share';

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
      args: {
        ...ConnectionArgs,
        feedType: FeedType,
      },
      nullable: false,
      ...requireAuthorization,
      resolve: async (_parent, args, ctx) => {
        const where = await shareWhere(ctx, args.feedType);

        return findManyCursor<Share>(
          (_args) =>
            ctx.prismaClient.share.findMany({
              where,
              ..._args,
              orderBy: {
                createdAt: 'desc',
              },
            }),
          args,
        );
      },
    });
  },
});
