import {schema} from 'nexus';
import {Attachment} from './attachment';

schema.objectType({
  name: 'Episode',
  definition(t) {
    t.implements(Attachment);
    t.model.id();
    t.model.title();
    t.model.podcast();
  },
});
