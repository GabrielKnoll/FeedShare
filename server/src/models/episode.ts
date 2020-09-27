import {schema} from 'nexus';
import {Attachment} from './attachment';

schema.objectType({
  name: 'Episode',
  definition(t) {
    t.implements(Attachment);
    t.model.podcast();
    t.model.durationSeconds();
    t.model.description();
  },
});
