import {interfaceType, intArg} from '@nexus/schema';

export default interfaceType({
  name: 'Attachment',
  definition(t) {
    t.field('id', {
      type: 'String',
      nullable: false,
    });
    t.field('title', {
      type: 'String',
      nullable: false,
    });
    t.field('description', {
      type: 'String',
      nullable: true,
    });
    t.field('artwork', {
      type: 'String',
      args: {
        size: intArg({
          required: true,
        }),
      },
      resolve: (root, {size}) =>
        // @ts-ignore
        root.artwork
          ?.replace('{w}', String(size))
          .replace('{h}', String(size))
          .replace('{f}', 'jpg') ?? null,
    });
    t.resolveType((item) => {
      if ('podcastId' in item) {
        return 'Episode';
      } else {
        return 'Podcast';
      }
    });
  },
});
