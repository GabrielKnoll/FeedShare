import {intArg, objectType} from '@nexus/schema';
import Attachment from './Attachment';

export default objectType({
  name: 'Podcast',
  definition(t) {
    t.implements(Attachment);

    t.model.feed();
    t.model.publisher();
  },
});
