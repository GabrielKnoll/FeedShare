import express from 'express';
import {ApolloServer, ApolloError} from 'apollo-server-express';
import schema from './schema';
import context from './context';
import env from './utils/env';
import feed from './routes/feed';
import {run} from 'graphile-scheduler';
import {taskList, schedules} from './tasks/index';

const server = new ApolloServer({
  context,
  schema,
  formatError: (err) => {
    if (!(err instanceof ApolloError)) {
      return new ApolloError(err.message);
    }
    return err;
  },
  introspection: true,
  playground: true,
});

(async () => {
  await run({
    connectionString: env.DATABASE_URL,
    concurrency: 1,
    taskList: taskList as any,
    schedules,
  });
  const app = express();
  app.get('/feed/:token', feed);
  server.applyMiddleware({app});

  app.listen({port: env.PORT}, () =>
    console.log(
      `🚀 Server ready at http://localhost:${env.PORT}${server.graphqlPath}`,
    ),
  );
})();
