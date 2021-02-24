import {createHash} from 'crypto';
import qs from 'query-string';
import {intArg, nonNull} from 'nexus';
import {NexusGenObjectNames, NexusGenFieldTypes} from '../types/api';
import {ObjectDefinitionBlock} from 'nexus/dist/core';

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
      const path = `/${encodeURIComponent(
        String(root[fieldName]),
      )}?${qs.stringify({
        fm: 'jpg',
        q: scale > 1 ? 40 : 60,
        h: size * scale,
        w: size * scale,
        fit: 'crop',
      })}`;
      const toSign = `${process.env.IMGIX_TOKEN}${path}`;
      return `https://feedshare.imgix.net${path}&s=${createHash('md5')
        .update(toSign)
        .digest('hex')}`;
    },
  });
}
