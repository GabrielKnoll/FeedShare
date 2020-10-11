import {extendType, stringArg} from '@nexus/schema';
import Attachment from '../models/Attachment';
import requireAuthorization from '../utils/requireAuthorization';
import resolveAttachmentUrl from '../utils/resolveAttachmentUrl';

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.field('attachmentForUrl', {
      type: Attachment,
      args: {
        url: stringArg({
          required: true,
        }),
      },
      ...requireAuthorization,
      resolve: async (_root, {url}) => {
        const attachment = await resolveAttachmentUrl(url);
        return attachment ?? null;
      },
    });
  },
});
