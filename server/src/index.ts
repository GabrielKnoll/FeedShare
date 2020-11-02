import schema from './schema';
import express from 'express';
import {
  ApolloServer,
  AuthenticationError,
  ApolloError,
} from 'apollo-server-express';
import context from './utils/context';
import env from './utils/env';
import ErrorReporter from './utils/ErrorReporter';
import feed from './routes/feed';

const app = express();

const server = new ApolloServer({
  schema,
  context,
  plugins: [ErrorReporter],
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
