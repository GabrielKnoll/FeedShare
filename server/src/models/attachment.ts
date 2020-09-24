import {interfaceType} from 'nexus/components/schema';

export const Attachment = interfaceType({
  name: 'Attachment',
  definition(t) {
    t.string('id');
    t.string('title');
    t.resolveType((item) => {
      if ('episodeId' in item) {
        return 'Episode';
      } else {
        return 'Podcast';
      }
    });
  },
});
