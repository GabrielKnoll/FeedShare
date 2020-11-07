import {enumType} from '@nexus/schema';

export default enumType({
  name: 'PodcastClient',
  members: ['Castro', 'ApplePodcasts', 'Overcast', 'PocketCasts', 'Spotify'],
});
