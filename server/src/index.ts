import schema from './schema';
import express from 'express';
import {ApolloServer, ApolloError} from 'apollo-server-express';
import context from './utils/context';
import env from './utils/env';
import NewRelicPlugin from '@newrelic/apollo-server-plugin';
import feed from './routes/feed';

const app = express();

const server = new ApolloServer({
  schema,
  context,
  plugins: env.NODE_ENV === 'production' ? [NewRelicPlugin] : [],
  formatError: (err) => {
    if (!(err instanceof ApolloError)) {
      return new ApolloError(err.message);
    }
    return err;
  },
  introspection: true,
  playground: true,
});

server.applyMiddleware({app, path: '/graphql'});

app.get(`/feed/:handle`, feed);

app.listen({port: env.PORT}, () =>
  console.log(
    `🚀 Server ready at http://localhost:${env.PORT}${server.graphqlPath}`,
  ),
);
