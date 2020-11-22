import {extendType} from '@nexus/schema';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('podcastClient', {
      list: true,
      type: 'PodcastClient',
      resolve: async (_root, _args, ctx) => {
        const podcastClient = await ctx.prismaClient.podcastClient.findMany();
        return podcastClient;
      },
    });
  },
});
