import {interfaceType} from 'nexus';
import {
  NexusGenInterfaces,
  NexusGenFieldTypes,
  NexusGenAbstractTypeMembers,
} from '../../types/api';
import {generateId} from '../queries/node';

export default interfaceType({
  name: 'Node',
  resolveType: (node) =>
    ((node as any) as {__typename: NexusGenAbstractTypeMembers['Node']})
      .__typename,
  definition(t) {
    t.nonNull.id('id', {
      description: 'Unique identifier for the resource',
      resolve: (node, _args, _ctx, {parentType}) =>
        generateId(
          parentType.name as NexusGenAbstractTypeMembers['Node'],
          (node as NexusGenInterfaces['Node'] & NexusGenFieldTypes['Node']).id,
        ),
    });
  },
});
