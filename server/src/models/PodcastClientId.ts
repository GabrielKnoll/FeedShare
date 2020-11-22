import {enumType} from '@nexus/schema';
import {PodcastClientId} from '@prisma/client';

export default enumType({
  name: 'PodcastClientId',
  members: Object.keys(PodcastClientId),
});
