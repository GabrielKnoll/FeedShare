import {extendType} from 'nexus';
import fs from 'fs';
import {join} from 'path';
import {NexusGenObjects} from '../../types/api';

let cachedPages: Array<NexusGenObjects['Page']> | null = null;

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('pages', {
      type: 'Page',
      resolve: async () => {
        if (cachedPages) {
          return cachedPages;
        }
        const pagesFolder = join(__dirname, '..', '..', 'public', 'pages');
        const files = await fs.promises.readdir(pagesFolder);
        return Promise.all(
          files
            .filter((f) => f.endsWith('.md'))
            .map((f) =>
              fs.promises.readFile(join(pagesFolder, f)).then((content) => {
                const contentStr = content.toString().split('\n');
                const title =
                  contentStr.shift()?.replace(/^#\s/, '') ??
                  f.replace(/\.md$/, '');

                return {
                  content: contentStr.filter(Boolean).join('\n'),
                  id: f,
                  title,
                };
              }),
            ),
        );
      },
    });
  },
});
