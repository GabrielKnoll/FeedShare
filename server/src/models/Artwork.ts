import {enumType, intArg, interfaceType} from '@nexus/schema';
import {Episode, Podcast} from '@prisma/client';
import {UserInputError} from 'apollo-server-express';

export default interfaceType({
  name: 'Artwork',
  definition(t) {
    t.resolveType((root) =>
      root.hasOwnProperty('feed') ? 'Podcast' : 'Episode',
    );
    t.field('artwork', {
      type: 'String',
      args: {
        size: intArg(),
        format: enumType({
          name: 'ArtworkFormat',
          members: ['png', 'webp', 'jpg', 'heic'],
        }),
      },
      resolve: (root, {size = 100, format = 'png'}) => {
        if (!size) {
          throw new UserInputError('Missing "size" arg');
        }
        if (!format) {
          throw new UserInputError('Missing "format" arg');
        }

        return (
          (root as Podcast | Episode).artwork
            ?.replace('{w}', size.toString())
            .replace('{h}', size.toString())
            .replace('{f}', format) ?? null
        );
      },
    });
  },
});
