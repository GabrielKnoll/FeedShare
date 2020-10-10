import {extendType, stringArg, enumType} from '@nexus/schema';
import {ShareCreateInput} from '@prisma/client';

const AttachmentType = enumType({
  members: ['Podcast', 'Episode'],
  name: 'AttachmentType',
});

export default extendType({
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
        {prismaClient, userId},
      ) => {
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
          const res = await prismaClient.episode.findOne({
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

        return prismaClient.share.create({
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
