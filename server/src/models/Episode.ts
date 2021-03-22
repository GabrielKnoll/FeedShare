import {Episode} from '@prisma/client';
import {htmlToText} from 'html-to-text';
import {objectType} from 'nexus';
import imageField from '../utils/imageField';
import Node from './Node';

export default objectType({
  name: 'Episode',
  definition(t) {
    t.implements(Node);

    t.model.title();
    t.field('description', {
      type: 'String',
      resolve: async (root) => {
        return htmlToText((root as Episode).description ?? '', {
          tags: {
            a: {options: {ignoreHref: true}},
            ul: {options: {itemPrefix: '• '}},
          },
          wordwrap: false,
        }).trim();
      },
    });
    t.model.podcast();
    t.model.durationSeconds();
    t.model.datePublished();
    t.model.url();
    imageField(t, 'artwork');
  },
});
