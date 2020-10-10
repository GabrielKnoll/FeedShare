import {PrismaClient} from '@prisma/client';
import prismaClient from './prismaClient';
import jwt from 'jsonwebtoken';
import {ContextCallback} from 'graphql-yoga/dist/types';

export type Context = {
  prismaClient: PrismaClient;
  userId?: string;
};

const context: ContextCallback = ({request}): Context => {
  const auth = request.headers.authorization?.match(/^Bearer (.+)$/);
  let userId;
  try {
    if (auth && jwt.verify(auth[1], 'secret')) {
      const parsed = jwt.decode(auth[1]);
      if (typeof parsed !== 'string') {
        userId = parsed?.userId;
      }
    }
  } catch (e) {}
  return {prismaClient, userId};
};

export default context;
