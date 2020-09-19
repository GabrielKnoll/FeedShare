import {schema} from 'nexus';

schema.objectType({
  name: 'User',
  definition(t) {
    t.model.id();
    t.model.handle();
    t.field('isViewer', {
      type: 'Boolean',
      // @ts-ignore
      resolve: (parent, _, ctx) => ctx.token?.user === parent.id,
    });
    t.model.Share();
  },
});
