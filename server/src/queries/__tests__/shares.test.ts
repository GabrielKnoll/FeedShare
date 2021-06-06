import prismaClient from '../../utils/prismaClient';
import {personalFeedShares} from '../shares';

describe('personalFeedShares', () => {
  beforeAll(async () => {
    const [{current_database}] = await prismaClient.$queryRaw(
      'SELECT current_database();',
    );
    if (current_database !== 'podcast_test') {
      process.exit(1);
    }

    await prismaClient.user.createMany({
      data: [
        {
          id: 'user1',
          handle: 'user1',
          feedToken: '1',
        },
        {
          id: 'user2',
          handle: 'user2',
          feedToken: '2',
        },
        {
          id: 'user3',
          handle: 'user3',
          feedToken: '3',
        },
      ],
      skipDuplicates: true,
    });

    await prismaClient.twitterAccount.createMany({
      data: [
        {
          id: 'twitter1',
          userId: 'user1',
          following: ['twitter2'],
        },
        {
          id: 'twitter2',
          userId: 'user2',
          following: ['twitter1'],
        },
      ],
      skipDuplicates: true,
    });

    await prismaClient.podcast.createMany({
      data: {
        id: 'podcast1',
        title: 'podcast1',
        publisher: 'publisher1',
      },
      skipDuplicates: true,
    });

    await prismaClient.episode.createMany({
      data: [
        {
          id: 'episode1',
          datePublished: new Date('2020-01-01'),
          title: 'episode1',
          enclosureUrl: 'http://episode1.de',
          podcastId: 'podcast1',
        },
        {
          id: 'episode2',
          datePublished: new Date('2020-01-01'),
          title: 'episode2',
          enclosureUrl: 'http://episode2.de',
          podcastId: 'podcast1',
        },
        {
          id: 'episode3',
          datePublished: new Date('2020-01-01'),
          title: 'episode3',
          enclosureUrl: 'http://episode3.de',
          podcastId: 'podcast1',
        },
        {
          id: 'episode4',
          datePublished: new Date('2020-01-01'),
          title: 'episode4',
          enclosureUrl: 'http://episode4.de',
          podcastId: 'podcast1',
        },
      ],
      skipDuplicates: true,
    });

    await prismaClient.share.createMany({
      data: [
        {
          id: 'share1',
          authorId: 'user1',
          episodeId: 'episode1',
          createdAt: new Date('2020-01-02'),
        },
        {
          id: 'share2',
          authorId: 'user2',
          episodeId: 'episode2',
          createdAt: new Date('2020-01-03'),
        },
        {
          id: 'share3',
          authorId: 'user3',
          episodeId: 'episode3',
          createdAt: new Date('2020-01-01'),
        },
        {
          id: 'share4',
          authorId: 'user3',
          episodeId: 'episode4',
          createdAt: new Date('2020-01-04'),
        },
      ],
      skipDuplicates: true,
    });
  });

  afterAll(async () => {
    await prismaClient.twitterAccount.deleteMany({});
    await prismaClient.addedToPersonalFeed.deleteMany({});
    await prismaClient.share.deleteMany({});
    await prismaClient.user.deleteMany({});
    await prismaClient.episode.deleteMany({});
    await prismaClient.podcast.deleteMany({});
  });

  beforeEach(async () => {
    await prismaClient.addedToPersonalFeed.deleteMany({});
  });

  it('includes shares from friends', async () => {
    const shares = await personalFeedShares(
      prismaClient,
      false,
      'user1',
      100,
      0,
    );
    expect(shares.length).toBe(1);
    expect(shares[0].id).toBe('share2');
  });

  it('includes shares from user', async () => {
    const shares = await personalFeedShares(
      prismaClient,
      true,
      'user1',
      100,
      0,
    );
    expect(shares.length).toBe(2);
    expect(shares[0].id).toBe('share2');
    expect(shares[1].id).toBe('share1');
  });

  it('includes shares from user', async () => {
    await prismaClient.addedToPersonalFeed.create({
      data: {
        shareId: 'share3',
        userId: 'user1',
      },
    });
    let shares = await personalFeedShares(prismaClient, true, 'user1', 100, 0);
    expect(shares.length).toBe(3);
    expect(shares[0].id).toBe('share3');
    expect(shares[1].id).toBe('share2');
    expect(shares[2].id).toBe('share1');

    shares = await personalFeedShares(prismaClient, true, 'user1', 1, 1);
    expect(shares.length).toBe(1);
    expect(shares[0].id).toBe('share2');

    shares = await personalFeedShares(prismaClient, true, 'user1', 1, 2);
    expect(shares.length).toBe(1);
    expect(shares[0].id).toBe('share1');
  });
});
