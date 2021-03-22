import {objectType, intArg} from 'nexus';
import {Podcast} from '@prisma/client';
import {fullPodcastById, latestEpisodes} from '../utils/podcastIndex';
import imageField from '../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'Podcast',
  definition(t) {
    imageField(t, 'artwork');
    t.implements(Node);

    t.model.title();
    t.field('description', {
      type: 'String',
      resolve: async (root, _args, context) => {
        context.podcastApiRequest =
          context.podcastApiRequest ??
          fullPodcastById(parseInt((root as Podcast).id, 10));
        const data = await context.podcastApiRequest;
        return data.feed.description;
      },
    });

    t.field('url', {
      type: 'String',
      resolve: async (root, _args, context) => {
        context.podcastApiRequest =
          context.podcastApiRequest ??
          fullPodcastById(parseInt((root as Podcast).id, 10));
        const data = await context.podcastApiRequest;
        return data.feed.link;
      },
    });

    t.nonNull.field('feed', {
      type: 'String',
      resolve: async (root, _args, context) => {
        context.podcastApiRequest =
          context.podcastApiRequest ??
          fullPodcastById(parseInt((root as Podcast).id, 10));
        const data = await context.podcastApiRequest;
        return data.feed.url;
      },
    });
    t.model.publisher();
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
