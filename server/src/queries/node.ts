import {extendType, idArg, nonNull} from '@nexus/schema';
import Node from '../models/Node';
import requireAuthorization from '../utils/requireAuthorization';
import {NexusGenAbstractTypeMembers} from 'nexus-typegen';
import UnreachableCaseError from '../utils/UnreachableCaseError';
import {Prisma} from '@prisma/client';
import {ResultValue} from '@nexus/schema/dist/core';
import {ApolloError} from 'apollo-server-express';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('node', {
      type: Node,
      args: {
        id: nonNull(idArg()),
      },
      ...requireAuthorization,
      resolve: async (_parent, {id}, {prismaClient}) => {
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

        const node: ResultValue<
          'Query',
          'node'
        > | null = await (delegate as Prisma.PodcastDelegate).findUnique({
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

export function parseId(
  id: string,
): {
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
