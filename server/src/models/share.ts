import {schema} from 'nexus';

schema.objectType({
  name: 'Share',
  definition(t) {
    t.model.id();
    t.model.author();
    t.model.message();
    t.model.createdAt();

    t.field('attachment', {
      type: 'Attachment',
      resolve: async (root, _ctx, {db}) => {
        const sharable = await db.share.findOne({
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
