import {PrismaClient} from '@prisma/client';
import prismaClient from './prismaClient';
import jwt from 'jsonwebtoken';
import {ContextCallback} from 'graphql-yoga/dist/types';
import env from './env';

type ParsedToken = {
  userId: string;
};

export type Context = {
  prismaClient: PrismaClient;
  token?: string;
} & Partial<ParsedToken>;

function parseToken(token: string) {
  try {
    if (token && jwt.verify(token, env.JWT_SECRET)) {
      return jwt.decode(token) as ParsedToken;
    }
  } catch (e) {}
}

export function generateToken(parsed: ParsedToken): string {
  return jwt.sign(parsed, env.JWT_SECRET);
}

const context: ContextCallback = ({request}): Context => {
  const auth = request.headers.authorization?.match(/^Bearer (.+)$/) ?? [];
  return {prismaClient, ...parseToken(auth[1]), token: auth[1]};
};

export default context;
