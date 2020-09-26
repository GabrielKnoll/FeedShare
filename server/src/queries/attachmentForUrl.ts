import {stringArg} from 'nexus/components/schema';
import {schema} from 'nexus';
import {Attachment} from '../models/attachment';
import requireAuthorization from '../utils/requireAuthorization';
import resolveAttachmentUrl from '../utils/resolveAttachmentUrl';

schema.extendType({
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
      resolve: async (_, {url}, {db, token}) => {
        const attachment = await resolveAttachmentUrl(url);
        return attachment ?? null;
      },
    });
  },
});
