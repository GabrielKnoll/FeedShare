require('dotenv').config({path: '../.env'});

import schema from './schema';
import {GraphQLServer} from 'graphql-yoga';
import context from './utils/context';

const server = new GraphQLServer({
  // @ts-ignore
  schema,
  context,
});

server.start(
  {port: process.env.PORT || 4000},
  (options) => `Server is running on http://localhost:${options.port}`,
);
