import {objectType} from '@nexus/schema';
import imageField from '../utils/imageField';

export default objectType({
  name: 'User',
  definition(t) {
    t.model.id();
    t.model.handle();
    t.field('isViewer', {
      type: 'Boolean',
      resolve: (parent, _, {userId}) => userId === parent.id,
    });
    t.model.displayName();
    imageField(t, 'profilePicture');
  },
});
