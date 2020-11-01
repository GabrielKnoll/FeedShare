import {objectType, intArg} from '@nexus/schema';

export default objectType({
  name: 'Podcast',
  definition(t) {
    t.model.id();
    t.model.title();
    t.model.artwork();
    t.model.description();
    t.model.feed();
    t.model.publisher();
    t.field('latestEpisodes', {
      type: 'Episode',
      list: true,
      nullable: false,
      args: {
        length: intArg({
          default: 10,
        }),
      },
      resolve: async () => {
        console.log('resolver called');
        return [];
      },
    });
  },
});
