import {objectType} from '@nexus/schema';
import imageField from '../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'User',
  definition(t) {
    t.implements(Node);

    t.model.handle();
    t.model.displayName();
    imageField(t, 'profilePicture');
  },
});
