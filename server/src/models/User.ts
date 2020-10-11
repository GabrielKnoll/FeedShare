import {objectType} from '@nexus/schema';

export default objectType({
  name: 'User',
  definition(t) {
    t.model.id();
    t.model.handle();
    t.field('isViewer', {
      type: 'Boolean',
      resolve: (parent, _, {userId}) => userId === parent.id,
    });
    // t.model.Share();
    t.model.displayName();
    t.model.profilePicture();
  },
});
