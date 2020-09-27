import {interfaceType, intArg} from 'nexus/components/schema';

export const Attachment = interfaceType({
  name: 'Attachment',
  definition(t) {
    t.field('id', {
      type: 'String',
      resolve: (root) => root.id,
      nullable: false,
    });
    t.field('title', {
      type: 'String',
      resolve: (root) => root.title,
      nullable: false,
    });
    t.field('artwork', {
      type: 'String',
      args: {
        size: intArg({
          required: true,
        }),
      },
      resolve: (root, {size}) => {
        return (
          root.artwork
            ?.replace('{w}', String(size))
            .replace('{h}', String(size))
            .replace('{f}', 'jpg') ?? null
        );
      },
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
