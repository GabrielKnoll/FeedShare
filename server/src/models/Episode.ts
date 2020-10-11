import {intArg, objectType} from '@nexus/schema';
import Attachment from './Attachment';

export default objectType({
  name: 'Episode',
  definition(t) {
    t.implements(Attachment);

    t.model.podcast();
    t.model.durationSeconds();
  },
});
