import {GraphQLClient} from 'graphql-request';
import {getSdk} from './datoCMS.generated';

const graphQLClient = new GraphQLClient('https://graphql.datocms.com', {
  headers: {
    authorization: `Bearer ${process.env.DATO_CMS_KEY}`,
  },
});

export default getSdk(graphQLClient);
