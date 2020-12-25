import schema from '../../graphql/schema';
import {ApolloServer, ApolloError} from 'apollo-server-micro';
import context from '../../utils/context';

const server = new ApolloServer({
  schema,
  context,
  formatError: (err) => {
    if (!(err instanceof ApolloError)) {
      return new ApolloError(err.message);
    }
    return err;
  },

  introspection: true,
  playground: true,
});

export const config = {
  api: {
    bodyParser: false,
  },
};

export default server.createHandler({path: '/api/graphql'});
