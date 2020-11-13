import PodcastIndexClient from 'podcastdx-client';
import env from './env';

const podcastIndexClient = new PodcastIndexClient({
  key: env.PODCAST_INDEX_KEY,
  secret: env.PODCAST_INDEX_SECRET,
});

export default podcastIndexClient;
