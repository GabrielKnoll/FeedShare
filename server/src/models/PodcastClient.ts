import {objectType} from 'nexus';
import Node from './Node';
import {PodcastClient as P} from 'nexus-prisma';

export default objectType({
  name: 'PodcastClient',
  definition(t) {
    t.implements(Node);

    t.field(P.displayName);
    t.field(P.icon);
    t.field(P.subscribeUrl);
    t.field(P.subscribeUrlNeedsProtocol);
  },
});
