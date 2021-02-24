import {objectType} from 'nexus';
import Node from './Node';

export default objectType({
  name: 'PodcastClient',
  definition(t) {
    t.implements(Node);

    t.model.displayName();
    t.model.icon();
    t.model.subscribeUrl();
    t.model.subscribeUrlNeedsProtocol();
  },
});
