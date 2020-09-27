import {schema} from 'nexus';
import parseToken from '../utils/parseToken';

schema.objectType({
  name: 'User',
  definition(t) {
    t.model.id();
    t.model.handle();
    t.field('isViewer', {
      type: 'Boolean',
      resolve: (parent, _, {token}) => parseToken(token).userId === parent.id,
    });
    t.model.Share();
    t.model.displayName();
    t.model.profilePicture();
  },
});
