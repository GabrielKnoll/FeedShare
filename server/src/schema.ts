import {nexusSchemaPrisma} from 'nexus-plugin-prisma/schema';
import prismaClient from './utils/prismaClient';
import {asNexusMethod, makeSchema} from '@nexus/schema';
import attachmentForUrl from './queries/attachmentForUrl';
import viewer from './queries/viewer';
import shares from './queries/shares';
import createViewer from './mutations/createViewer';
import createShare from './mutations/createShare';
import User from './models/User';
import Viewer from './models/Viewer';
import Attachment from './models/Attachment';
import Podcast from './models/Podcast';
import Episode from './models/Episode';
import Share from './models/Share';
import {DateTimeResolver, JSONObjectResolver} from 'graphql-scalars';

export default makeSchema({
  typegenAutoConfig: {
    contextType: 'Context.Context',
    sources: [
      {source: '@prisma/client', alias: 'PrismaClient.PrismaClient'},
      {source: require.resolve('./utils/context'), alias: 'Context'},
    ],
  },
  outputs: {
    schema: __dirname + '/../api.graphql',
    typegen: __dirname + '/../node_modules/@types/nexus-typegen/index.d.ts',
  },
  types: [
    asNexusMethod(JSONObjectResolver, 'json'),
    asNexusMethod(DateTimeResolver, 'date'),

    // modesl
    Viewer,
    User,
    Attachment,
    Podcast,
    Episode,
    Share,

    // queries
    attachmentForUrl,
    shares,
    viewer,

    // mutations
    createViewer,
    createShare,
  ],
  plugins: [
    nexusSchemaPrisma({
      prismaClient: () => prismaClient,
    }),
  ],
});
