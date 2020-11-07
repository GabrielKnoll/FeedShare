import {objectType, intArg} from '@nexus/schema';
import {Podcast} from '@prisma/client';
import {ApolloError, UserInputError} from 'apollo-server-express';
import {latestEpisodes} from '../utils/appleApi';
import UnreachableCaseError from '../utils/UnreachableCaseError';
import Artwork from './Artwork';
import PodcastClient from './PodcastClient';

export default objectType({
  name: 'Podcast',
  definition(t) {
    t.implements(Artwork);
    t.model.id();
    t.model.title();
    t.model.description();
    t.model.feed();
    t.model.publisher();
    t.field('latestEpisodes', {
      type: 'Episode',
      list: true,
      nullable: false,
      args: {
        length: intArg({
          default: 5,
        }),
      },
      resolve: (root, {length}) => latestEpisodes(root as Podcast, length),
    });

    t.field('subscribeLink', {
      type: 'String',
      nullable: true,
      args: {
        client: PodcastClient,
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
          case 'Spotify':
            return `castro://subscribe/${url}`;
          case 'PocketCasts':
            return `pktc://subscribe/${url}`;
          default:
            throw new UnreachableCaseError(client);
        }
      },
    });
  },
});
