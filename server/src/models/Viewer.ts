import {objectType} from '@nexus/schema';
import {User} from '@prisma/client';
import {NexusGenRootTypes} from 'nexus-typegen';
import {Context} from '../utils/context';

export default objectType({
  name: 'Viewer',
  definition(t) {
    t.field('personalFeed', {
      type: 'String',
      nullable: false,
    });
    t.field('user', {
      type: 'User',
      nullable: false,
    });
    t.field('token', {
      type: 'String',
      nullable: false,
    });
  },
});

export function getViewer(
  user: User,
  context: Context,
): NexusGenRootTypes['Viewer'] {
  return {
    user,
    personalFeed: `https://feed.buechele.cc/feed/${user.handle}`,
    token: context.token!,
  };
}
