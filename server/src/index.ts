import schema from './schema';
import {GraphQLServer} from 'graphql-yoga';
import context from './utils/context';
import env from './utils/env';
import feed from './routes/feed';

const server = new GraphQLServer({
  // @ts-ignore
  schema,
  context,
});

server.start(
  {port: env.PORT},
  (options) => `Server is running on http://localhost:${options.port}`,
);

server.express.get(`/feed/:handle`, feed);
