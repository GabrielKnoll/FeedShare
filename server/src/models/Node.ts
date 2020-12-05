import {interfaceType} from '@nexus/schema';

export default interfaceType({
  name: 'Node',
  resolveType: () => 'Podcast' as const,
  definition(t) {
    t.id('id', {
      description: 'Unique identifier for the resource',
      nullable: false,
    });
  },
});
