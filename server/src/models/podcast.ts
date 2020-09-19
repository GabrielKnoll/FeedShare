import {schema} from 'nexus';

schema.objectType({
  name: 'Podcast',
  definition(t) {
    t.model.id();
    t.model.title();
  },
});
