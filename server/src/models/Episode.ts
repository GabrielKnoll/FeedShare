import {objectType} from '@nexus/schema';
import Artwork from './Artwork';

export default objectType({
  name: 'Episode',
  definition(t) {
    t.model.id();
    t.model.title();
    t.model.description();
    t.model.podcast();
    t.model.durationSeconds();

    t.implements(Artwork);
  },
});
