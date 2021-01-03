import {nexusPrisma} from 'nexus-plugin-prisma';
import prismaClient from '../utils/prismaClient';
import {
  asNexusMethod,
  fieldAuthorizePlugin,
  makeSchema,
  connectionPlugin,
} from 'nexus';
import resolveShareUrl from './queries/resolveShareUrl';
import viewer from './queries/viewer';
import shares from './queries/shares';
import findPodcast from './queries/findPodcast';
import typeaheadPodcast from './queries/typeaheadPodcast';
import node from './queries/node';
import pages from './queries/pages';
import podcastClient from './queries/podcastClient';
import createViewer from './mutations/createViewer';
import createShare from './mutations/createShare';
import Node from './models/Node';
import User from './models/User';
import Page from './models/Page';
import Viewer from './models/Viewer';
import Podcast from './models/Podcast';
import SearchResult from './models/SearchResult';
import PodcastClient from './models/PodcastClient';
import FeedType from './models/FeedType';
import Episode from './models/Episode';
import Share from './models/Share';
import {DateTimeResolver, JSONObjectResolver} from 'graphql-scalars';
import {AuthenticationError} from 'apollo-server-micro';
import {join} from 'path';
import getConfig from 'next/config';

const {serverRuntimeConfig} = getConfig();

export default makeSchema({
  contextType: {
    module: join(serverRuntimeConfig.PROJECT_ROOT, 'utils', 'context.ts'),
    alias: 'ctx',
    export: 'Context',
  },
  outputs: {
    schema: join(serverRuntimeConfig.PROJECT_ROOT, 'api.graphql'),
    typegen: join(serverRuntimeConfig.PROJECT_ROOT, 'types', 'api.d.ts'),
  },
  types: [
    asNexusMethod(JSONObjectResolver, 'json'),
    asNexusMethod(DateTimeResolver, 'date'),

    // models
    Node,
    Viewer,
    User,
    Podcast,
    Episode,
    Share,
    PodcastClient,
    FeedType,
    SearchResult,
    Page,

    // queries
    resolveShareUrl,
    shares,
    viewer,
    podcastClient,
    findPodcast,
    typeaheadPodcast,
    node,
    pages,

    // mutations
    createViewer,
    createShare,
  ],
  plugins: [
    nexusPrisma({
      prismaClient: () => prismaClient,
    }),
    fieldAuthorizePlugin({
      formatError: () => new AuthenticationError('Not authorized'),
    }),
    connectionPlugin(),
    connectionPlugin({
      typePrefix: 'Countable',
      nexusFieldName: 'countableConnection',
      extendConnection: {
        totalCount: {type: 'Int'},
      },
    }),
  ],
  shouldGenerateArtifacts: process.env.NODE_ENV === 'development',
});
