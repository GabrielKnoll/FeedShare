import express from 'express';
import {ApolloServer, ApolloError} from 'apollo-server-express';
import schema from './schema';
import context from './context';
import env from './utils/env';
import feed from './routes/feed';
import tasks from './tasks';
import {ApolloServerPluginLandingPageGraphQLPlayground} from 'apollo-server-core';

const server = new ApolloServer({
  context,
  schema: schema as any,
  formatError: (err) => {
    if (!(err instanceof ApolloError)) {
      return new ApolloError(err.message);
    }
    return err;
  },
  plugins: [ApolloServerPluginLandingPageGraphQLPlayground()],
  introspection: true,
});

(async () => {
  await tasks();

  const app = express();
  app.get('/feed/:token', feed);
  await server.start();
  server.applyMiddleware({app});

  app.listen({port: env.PORT}, () =>
    console.log(
      `🚀 Server ready at http://localhost:${env.PORT}${server.graphqlPath}`,
    ),
  );
})();
