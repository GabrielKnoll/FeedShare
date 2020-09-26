import {stringArg, enumType} from 'nexus/components/schema';
import {schema} from 'nexus';
import parseToken from '../utils/parseToken';
import {ShareCreateInput} from '@prisma/client';

const AttachmentType = enumType({
  members: ['Podcast', 'Episode'],
  name: 'AttachmentType',
});

schema.extendType({
  type: 'Mutation',
  definition: (t) => {
    t.field('createShare', {
      type: 'Share',
      args: {
        message: stringArg({
          required: false,
        }),
        attachmentId: stringArg({
          required: true,
        }),
        attachmentType: AttachmentType,
      },
      resolve: async (
        _,
        {message, attachmentId, attachmentType},
        {db, token},
      ) => {
        const {userId} = parseToken(token);
        if (!userId) {
          throw new Error('No user');
        }

        if (!attachmentType) {
          throw new Error('No attachmentType');
        }

        let podcastId = attachmentId;
        let episode: {
          episode?: ShareCreateInput['episode'];
        } = {};
        if (attachmentType === 'Episode') {
          const res = await db.episode.findOne({
            where: {
              id: attachmentId,
            },
          });
          if (!res) {
            throw new Error('Episode not found');
          }
          podcastId = res.podcastId;
          episode = {
            episode: {
              connect: {
                id: attachmentId,
              },
            },
          };
        }

        return db.share.create({
          data: {
            podcast: {
              connect: {
                id: podcastId,
              },
            },
            ...episode,
            message: message,
            author: {
              connect: {
                id: userId,
              },
            },
          },
        });
      },
    });
  },
});
