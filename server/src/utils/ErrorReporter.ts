import {Timber} from '@timberio/node';
import env from './env';
import {ApolloServerPlugin} from 'apollo-server-plugin-base';
import {Context} from './context';
import {ApolloError} from 'apollo-server-express';
import {performance} from 'perf_hooks';

const timber = new Timber(env.TIMBER_TOKEN, env.TIMBER_SOUCE_ID);

const plugin: ApolloServerPlugin<Context> = {
  requestDidStart() {
    const start = performance.now();
    return {
      willSendResponse({debug, request: {query, operationName}}) {
        const took = performance.now() - start;
        if (operationName === 'IntrospectionQuery') {
          return;
        }

        if (debug) {
          console.info(`Request took: ${took}ms, ${operationName}`);
        } else {
          timber.info<any>(`Request took: ${took}ms`, {
            took,
            query,
            operationName,
          });
        }
      },
      didEncounterErrors({
        errors,
        context: {userId},
        request: {query, variables, operationName},
        debug,
      }) {
        errors.forEach((e) => {
          const message = (e as ApolloError).stack ?? e.message;
          if (debug) {
            console.error(message);
          } else {
            timber.error<any>(message, {
              errorName: e.name,
              userId,
              query,
              operationName,
              variables_json: variables,
            });
          }
        });
      },
    };
  },
};

export default plugin;
