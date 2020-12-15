import {objectType} from '@nexus/schema';
import Node from './Node';

export default objectType({
  name: 'SearchResult',
  definition(t) {
    t.id('id');
    t.nonNull.string('title');
  },
});
