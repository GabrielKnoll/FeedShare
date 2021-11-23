import prismaClient from './utils/prismaClient';
import {
  asNexusMethod,
  fieldAuthorizePlugin,
  makeSchema,
  connectionPlugin,
  subscriptionType,
} from 'nexus';
import resolveShareUrl from './queries/resolveShareUrl';
import viewer from './queries/viewer';
import {globalFeed, personalFeed, userFeed} from './queries/shares';
import findPodcast from './queries/findPodcast';
import typeaheadPodcast from './queries/typeaheadPodcast';
import node from './queries/node';
import pages from './queries/pages';
import podcastClient from './queries/podcastClient';
import createViewer from './mutations/createViewer';
import createShare from './mutations/createShare';
import addToPersonalFeed from './mutations/addToPersonalFeed';
import Node from './models/Node';
import User from './models/User';
import Page from './models/Page';
import Viewer from './models/Viewer';
import Podcast from './models/Podcast';
import SearchResult from './models/SearchResult';
import PodcastClient from './models/PodcastClient';
import Episode from './models/Episode';
import Share from './models/Share';
import {DateTimeResolver, JSONObjectResolver} from 'graphql-scalars';
import {AuthenticationError} from 'apollo-server-express';
import {join} from 'path';
import env from './utils/env';

export default makeSchema({
  contextType: {
    module: join(__dirname, 'context.ts'),
    alias: 'ctx',
    export: 'Context',
  },
  outputs: {
    schema: join(__dirname, '..', 'schema.graphql'),
    typegen: join(__dirname, '..', 'types', 'api.d.ts'),
  },
  types: [
    asNexusMethod(JSONObjectResolver, 'json'),
    asNexusMethod(DateTimeResolver, 'date'),

    subscriptionType({
      definition(t) {
        t.boolean('truths', {
          subscribe() {
            return (async function* () {
              while (true) {
                await new Promise((res) => setTimeout(res, 1000));
                yield Math.random() > 0.5;
              }
            })();
          },
          resolve(eventData: boolean) {
            return eventData;
          },
        });
      },
    }),

    // models
    Node,
    Viewer,
    User,
    Podcast,
    Episode,
    Share,
    PodcastClient,
    SearchResult,
    Page,

    // queries
    resolveShareUrl,
    globalFeed,
    personalFeed,
    userFeed,
    viewer,
    podcastClient,
    findPodcast,
    typeaheadPodcast,
    node,
    pages,

    // mutations
    createViewer,
    createShare,
    addToPersonalFeed,
  ],
  plugins: [
    fieldAuthorizePlugin({
      formatError: () => new AuthenticationError('Not authorized'),
    }),
    connectionPlugin({
      validateArgs: () => true,
    }),
    connectionPlugin({
      typePrefix: 'Countable',
      nexusFieldName: 'countableConnection',
      extendConnection: {
        totalCount: {type: 'Int'},
      },
    }),
  ],
  shouldGenerateArtifacts: env.NODE_ENV !== 'production',
});
