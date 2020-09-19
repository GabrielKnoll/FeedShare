import {schema} from 'nexus';

schema.objectType({
  name: 'Share',
  definition(t) {
    t.model.id();
    t.model.author();
    t.model.episode();
    t.model.message();
  },
});
