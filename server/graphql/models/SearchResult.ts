import {objectType} from '@nexus/schema';

export default objectType({
  name: 'SearchResult',
  definition(t) {
    t.id('feedId');
    t.nonNull.string('title');
  },
});
