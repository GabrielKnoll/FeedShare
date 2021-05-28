import {objectType} from 'nexus';
import {User} from '@prisma/client';
import {generateToken} from '../context';
import env from '../utils/env';

export default objectType({
  name: 'Viewer',
  definition(t) {
    t.nonNull.field('personalFeedUrl', {
      type: 'String',
      resolve: ({user}: {user: Partial<User>}) =>
        `${env.BASE_URL}/feed/${user.feedToken}`,
    });
    t.nonNull.field('user', {
      type: 'User',
    });
    t.nonNull.field('token', {
      type: 'String',
      resolve: ({user}: {user: Partial<User>}, _, ctx) =>
        ctx.token ?? generateToken({userId: user.id!}),
    });
    t.nonNull.field('messageLimit', {
      type: 'Int',
      resolve: () => 400,
    });
    t.field('personalFeedLastChecked', {
      type: 'DateTime',
      resolve: ({user}: {user: Partial<User>}) => user.feedCheckedAt,
    });
  },
});
