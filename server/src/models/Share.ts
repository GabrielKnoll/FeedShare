import {objectType} from '@nexus/schema';

export default objectType({
  name: 'Share',
  definition(t) {
    t.model.id();
    t.model.author();
    t.model.message();
    t.model.createdAt();
    t.model.episode();
  },
});
