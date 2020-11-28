import {objectType} from '@nexus/schema';
import imageField from '../utils/imageField';

export default objectType({
  name: 'Episode',
  definition(t) {
    t.model.id();
    t.model.title();
    t.model.description();
    t.model.podcast();
    t.model.durationSeconds();
    t.model.datePublished();
    imageField(t, 'artwork');
  },
});
