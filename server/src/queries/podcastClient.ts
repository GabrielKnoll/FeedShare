import {extendType} from 'nexus';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('podcastClient', {
      type: 'PodcastClient',
      resolve: async (_root, _args, ctx) => {
        const podcastClient = await ctx.prismaClient.podcastClient.findMany();
        return podcastClient;
      },
    });
  },
});
