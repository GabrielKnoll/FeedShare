import {objectType} from 'nexus';
import imageField from '../../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'Episode',
  definition(t) {
    t.implements(Node);

    t.model.title();
    t.model.description();
    t.model.podcast();
    t.model.durationSeconds();
    t.model.datePublished();
    t.model.url();
    imageField(t, 'artwork');
  },
});
