import {extendType, idArg, nonNull} from '@nexus/schema';
import Node from '../models/Node';
import requireAuthorization from '../utils/requireAuthorization';
import {NexusGenAbstractTypeMembers} from 'nexus-typegen';
import UnreachableCaseError from '../utils/UnreachableCaseError';
import {Prisma} from '@prisma/client';
import {ResultValue} from '@nexus/schema/dist/core';

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
        // @ts-ignore
        const [__typename, ...guid]: [
          NexusGenAbstractTypeMembers['Node'],
          ...string[]
        ] = id.split(':');

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
            id: guid.join(':'),
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
