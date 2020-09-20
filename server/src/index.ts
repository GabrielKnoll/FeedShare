require('dotenv').config();

import {schema, use, settings} from 'nexus';
import {prisma} from 'nexus-plugin-prisma';
import prismaClient from './prismaClient';
import {objectType} from 'nexus/components/schema';
import {PageInfo, ConnectionArgs} from './connections/connection';
import {findManyCursor} from './connections/findManyCursor';
import {auth} from 'nexus-plugin-jwt-auth';
import token from './utils/token';

settings.change({
  server: {
    port: parseInt(process.env.PORT || '4000', 10),
  },
});

use(
  prisma({
    client: {
      instance: prismaClient,
    },
    features: {
      crud: true,
    },
  }),
);

use(
  auth({
    appSecret: process.env.JWT_SECRET,
  }),
);

schema.queryType({
  definition(t) {
    t.crud.share();
    t.field('viewer', {
      type: objectType({
        name: 'Viewer',
        definition(t) {
          t.field('user', {
            type: 'User',
          });
          t.field('personalFeed', {
            type: 'String',
          });
        },
      }),
      authorize: (_, __, ctx) => Boolean(token(ctx).userId),
      resolve: async (_, _args, ctx) => ({
        user: await prismaClient.user.findOne({
          where: {
            id: token(ctx).userId,
          },
        }),
        personalFeed: 'https://feed.buechele.cc/feed',
      }),
    }),
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
        resolve: async (_parent, args, ctx) =>
          findManyCursor<any>(
            (_args) =>
              prismaClient.share.findMany({
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
