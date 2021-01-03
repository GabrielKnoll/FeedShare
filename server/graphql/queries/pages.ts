import {extendType} from '@nexus/schema';
import {gql} from 'graphql-request';
import datoCMS from '../../utils/datoCMS';

gql`
  query inAppPages {
    allInAppPages {
      id
      title
      contentHTML: content(markdown: true)
    }
  }
`;

export default extendType({
  type: 'Query',
  definition: (t) => {
    t.list.field('pages', {
      type: 'Page',
      resolve: async () => {
        const {allInAppPages} = await datoCMS.inAppPages();

        return allInAppPages.map(({title, id, contentHTML}) => ({
          title: title ?? '',
          id,
          contentHTML: `
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
                <style>body {font-family: -apple-system; font-size: 17px;}</style>
              </head>
              <body>
                ${contentHTML}
              </body>
            </html>
          `,
        }));
      },
    });
  },
});
