require('dotenv').config({path: '../.env'});

import {use, settings} from 'nexus';
import {prisma} from 'nexus-plugin-prisma';
import prismaClient from './utils/prismaClient';
import {auth} from 'nexus-plugin-jwt-auth';

settings.change({
  server: {
    port: parseInt(process.env.PORT || '4000', 10),
  },
});

use(
  prisma({
    client: {
      instance: prismaClient,
    },
    features: {
      crud: true,
    },
  }),
);

use(
  auth({
    appSecret: process.env.JWT_SECRET,
  }),
);

// schema.queryType({
//   definition(t) {
//     t.crud.share();
//   },
// });
