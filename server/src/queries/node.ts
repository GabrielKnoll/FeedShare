import {extendType, idArg} from '@nexus/schema';
import Node from '../models/Node';
import requireAuthorization from '../utils/requireAuthorization';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('node', {
      type: Node,
      args: {
        id: idArg({
          required: true,
        }),
      },
      ...requireAuthorization,
      resolve: async (_parent, {id}, {prismaClient}) => {
        return prismaClient.podcast.findOne({
          where: {
            id: parseInt(id, 10),
          },
        });
      },
    });
  },
});
