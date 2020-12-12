import {objectType} from '@nexus/schema';
import {User} from '@prisma/client';
import {NexusGenRootTypes} from 'nexus-typegen';
import {Context} from '../utils/context';

export default objectType({
  name: 'Viewer',
  definition(t) {
    t.nonNull.field('personalFeed', {
      type: 'String',
    });
    t.nonNull.field('user', {
      type: 'User',
    });
    t.nonNull.field('token', {
      type: 'String',
    });
    t.nonNull.field('messageLimit', {
      type: 'Int',
    });
  },
});

export function getViewer(
  user: User,
  context: Context,
): NexusGenRootTypes['Viewer'] {
  return {
    user,
    personalFeed: `https://feed.buechele.cc/feed/${user.feedToken}`,
    token: context.token!,
    messageLimit: 400,
  };
}
