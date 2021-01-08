import {objectType, intArg} from '@nexus/schema';
import {Podcast} from '@prisma/client';
import {latestEpisodes} from '../../utils/podcastIndex';
import imageField from '../../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'Podcast',
  definition(t) {
    imageField(t, 'artwork');
    t.implements(Node);

    t.model.title();
    t.model.description();
    t.model.feed();
    t.model.publisher();
    t.model.url();
    t.list.field('latestEpisodes', {
      type: 'Episode',
      args: {
        length: intArg({
          default: 10,
        }),
      },
      resolve: (root, {length}) =>
        latestEpisodes(root as Podcast, length ?? 10),
    });
  },
});
