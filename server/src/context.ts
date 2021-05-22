import {PrismaClient} from '@prisma/client';
import prismaClient from './utils/prismaClient';
import jwt from 'jsonwebtoken';
import {ContextFunction} from 'apollo-server-core';
import env from './utils/env';
import {ApiResponse} from 'podcastdx-client/dist/src/types';

type ParsedToken = {
  userId: string;
};

export type Context = {
  prismaClient: PrismaClient;
  token?: string;
  podcastApiRequest?: Promise<ApiResponse.Podcast>;
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

const context: ContextFunction = ({req}): Context => {
  const auth = req.headers.authorization?.match(/^Bearer (.+)$/) ?? [];
  return {prismaClient, ...parseToken(auth[1]), token: auth[1]};
};

export default context;
