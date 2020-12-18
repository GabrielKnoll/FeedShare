import {objectType} from '@nexus/schema';
import {User} from '@prisma/client';

export default objectType({
  name: 'Viewer',
  definition(t) {
    t.nonNull.field('personalFeed', {
      type: 'String',
      resolve: ({user}: {user: Partial<User>}) =>
        `https://feed.buechele.cc/feed/${user.feedToken}`,
    });
    t.nonNull.field('user', {
      type: 'User',
    });
    t.nonNull.field('token', {
      type: 'String',
      resolve: (_, __, ctx) => ctx.token!,
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
