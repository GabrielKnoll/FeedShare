import {objectType} from '@nexus/schema';

export default objectType({
  name: 'Share',
  definition(t) {
    t.model.id();
    t.model.author();
    t.model.message();
    t.model.createdAt();

    t.field('attachment', {
      type: 'Attachment',
      resolve: async (root, _ctx, {prismaClient}) => {
        const sharable = await prismaClient.share.findOne({
          where: {id: root.id},
          include: {episode: true, podcast: true},
        });
        if (!sharable) {
          throw new Error('No attachment');
        }
        return sharable.episode ?? sharable.podcast;
      },
    });
  },
});
