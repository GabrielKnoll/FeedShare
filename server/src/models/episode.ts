import {schema} from 'nexus';

schema.objectType({
  name: 'Episode',
  definition(t) {
    t.model.id();
    t.model.title();
    t.model.podcast();
  },
});
