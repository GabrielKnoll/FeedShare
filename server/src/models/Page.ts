import {objectType} from 'nexus';

export default objectType({
  name: 'Page',
  definition(t) {
    t.nonNull.id('id');
    t.nonNull.string('title');
    t.string('content');
  },
});
