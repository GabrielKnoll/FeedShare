import {Timber} from '@timberio/node';
import env from './env';
import {ApolloServerPlugin} from 'apollo-server-plugin-base';
import {Context} from './context';
import {ApolloError} from 'apollo-server-express';

const timber = new Timber(env.TIMBER_TOKEN, env.TIMBER_SOUCE_ID);

const plugin: ApolloServerPlugin<Context> = {
  requestDidStart() {
    return {
      async didEncounterErrors({
        errors,
        context: {userId},
        request: {query, variables, operationName},
        debug,
      }) {
        await Promise.all(
          errors.map((e) => {
            const message = (e as ApolloError).stack ?? e.message;
            if (debug) {
              console.error(message);
            } else {
              return timber.error<any>(message, {
                errorName: e.name,
                userId,
                query,
                operationName,
                variables_json: variables,
              });
            }
          }),
        );
      },
    };
  },
};

export default plugin;
