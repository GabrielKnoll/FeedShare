import {objectType, intArg} from '@nexus/schema';
import {Podcast} from '@prisma/client';
import {ApolloError, UserInputError} from 'apollo-server-express';
import {latestEpisodes} from '../utils/podcastIndex';
import imageField from '../utils/imageField';
import UnreachableCaseError from '../utils/UnreachableCaseError';
import PodcastClientId from './PodcastClientId';
import Node from './Node';

export default objectType({
  name: 'Podcast',
  definition(t) {
    t.implements(Node);
    imageField(t, 'artwork');

    t.model.title();
    t.model.description();
    t.model.feed();
    t.model.publisher();
    t.field('latestEpisodes', {
      type: 'Episode',
      list: true,
      nullable: true,
      args: {
        length: intArg({
          default: 10,
        }),
      },
      resolve: (root, {length}) =>
        latestEpisodes(root as Podcast, length ?? 10),
    });

    t.field('subscribeLink', {
      type: 'String',
      nullable: true,
      args: {
        client: PodcastClientId,
      },
      resolve({feed}, {client}) {
        if (!client) {
          throw new UserInputError('Argument "client" missing');
        }
        if (!feed) {
          throw new ApolloError('No feed available');
        }

        const url = feed.replace(/(^\w+:|^)\/\//, '');

        switch (client) {
          case 'ApplePodcasts':
            return `podcast://${url}`;
          case 'Castro':
            return `castro://subscribe/${url}`;
          case 'Overcast':
            return `overcast://x-callback-url/add?url=${encodeURIComponent(
              feed,
            )}`;
          case 'PocketCasts':
            return `pktc://subscribe/${url}`;
          case 'GooglePodcasts':
            return `todo`;
          default:
            throw new UnreachableCaseError(client);
        }
      },
    });
  },
});
