import {objectType} from '@nexus/schema';

export default objectType({
  name: 'PodcastClient',
  definition(t) {
    t.model.id();
    t.model.displayName();
    t.model.icon();
  },
});
