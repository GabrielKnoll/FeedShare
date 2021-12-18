import {extendType, idArg, nonNull} from 'nexus';
import Node from '../models/Node';
import requireAuthorization from '../utils/requireAuthorization';
import {NexusGenAbstractTypeMembers} from '../../types/api';
import UnreachableCaseError from '../utils/UnreachableCaseError';
import {Prisma} from '@prisma/client';
import {ApolloError} from 'apollo-server-express';
import {ResultValue} from 'nexus/dist/core';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('node', {
      type: Node,
      args: {
        id: nonNull(idArg()),
      },
      authorize: (_, {id}, {userId}) => {
        const {__typename} = parseId(id);
        // Shares don't need authentication
        return __typename === 'Share' || Boolean(userId);
      },
      resolve: async (_parent, {id}, {prismaClient, userId}) => {
        const {__typename, key} = parseId(id);

        if (!__typename) {
          throw new ApolloError('Unknown type');
        }

        let delegate;
        switch (__typename) {
          case 'Podcast':
            delegate = prismaClient.podcast;
            break;
          case 'Episode':
            delegate = prismaClient.episode;
            break;
          case 'Share':
            delegate = prismaClient.share;
            break;
          case 'User':
            delegate = prismaClient.user;
            break;
          case 'PodcastClient':
            delegate = prismaClient.podcastClient;
            break;
          default:
            new UnreachableCaseError(__typename);
            return null;
        }

        const node: ResultValue<'Query', 'node'> | null = await (
          delegate as Prisma.PodcastDelegate<any>
        ).findUnique({
          where: {
            id: key,
          },
        });

        if (!node) {
          return null;
        }

        return {__typename, ...node};
      },
    });
  },
});

export function parseId(id: string): {
  __typename?: NexusGenAbstractTypeMembers['Node'];
  key: string;
} {
  if (!id.includes(':')) {
    return {
      key: id,
    };
  }
  const [__typename, ...guid] = id.split(':');

  return {
    __typename: __typename as NexusGenAbstractTypeMembers['Node'],
    key: guid.join(':'),
  };
}

export function generateId(
  type: NexusGenAbstractTypeMembers['Node'],
  key: string,
) {
  return `${type}:${key}`;
}
