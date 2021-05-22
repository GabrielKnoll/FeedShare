import {intArg, nonNull} from 'nexus';
import {NexusGenObjectNames, NexusGenFieldTypes} from '../../types/api';
import {ObjectDefinitionBlock} from 'nexus/dist/core';
import imagekit, {urlEndpoint} from './imagekit';

export default function fieldConfig<TypeName extends NexusGenObjectNames>(
  t: ObjectDefinitionBlock<TypeName>,
  fieldName: keyof NexusGenFieldTypes[TypeName],
) {
  // @ts-ignore fieldName is string
  t.field(fieldName, {
    type: 'String',
    args: {
      size: nonNull(intArg()),
      scale: nonNull(intArg()),
    },
    resolve: (
      root: NexusGenFieldTypes[TypeName],
      {size, scale}: {size: number; scale: number},
    ) => {
      if (!root[fieldName]) {
        return null;
      }

      return imagekit.url({
        signed: true,
        src: `${urlEndpoint}/${root[fieldName]}`,
        transformationPosition: 'path',
        transformation: [
          {
            format: 'webp',
            width: String(size * scale),
            height: String(size * scale),
            quality: String(scale > 1 ? 40 : 60),
            cropMode: 'center',
          },
        ],
      });
    },
  });
}
