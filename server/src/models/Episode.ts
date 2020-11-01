import {intArg, objectType} from '@nexus/schema';

export default objectType({
  name: 'Episode',
  definition(t) {
    t.model.id();
    t.model.title();
    t.model.artwork();
    t.model.description();
    t.model.podcast();
    t.model.durationSeconds();
  },
});
