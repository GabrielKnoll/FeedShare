import {interfaceType} from '@nexus/schema';
import {
  NexusGenInterfaces,
  NexusGenFieldTypes,
  NexusGenAbstractTypeMembers,
} from 'nexus-typegen';

export default interfaceType({
  name: 'Node',
  resolveType: (node) =>
    ((node as any) as {__typename: NexusGenAbstractTypeMembers['Node']})
      .__typename,
  definition(t) {
    t.nonNull.id('id', {
      description: 'Unique identifier for the resource',
      resolve: (node, _args, _ctx, {parentType}) => {
        return `${parentType.name}:${
          (node as NexusGenInterfaces['Node'] & NexusGenFieldTypes['Node']).id
        }`;
      },
    });
  },
});
