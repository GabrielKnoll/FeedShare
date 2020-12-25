import {create} from 'xmlbuilder2';
import {RequestHandler} from 'express';
import prismaClient from '../../utils/prismaClient';
import {shareWhere} from '../../graphql/models/Share';

const requestHandler: RequestHandler<{
  feedToken: string;
}> = async (req, res) => {
  const user = await prismaClient.user.update({
    data: {
      feedCheckedAt: new Date(),
    },
    where: {
      feedToken: req.params.feedToken,
    },
    include: {
      twitterAccount: true,
    },
  });

  const shares = await prismaClient.share.findMany({
    include: {
      episode: {
        include: {
          podcast: true,
        },
      },
      author: true,
    },
    take: 100,
    where: await shareWhere({userId: user.id, prismaClient}, 'Friends'),
    orderBy: {
      createdAt: 'desc',
    },
  });

  // https://help.apple.com/itc/podcasts_connect/#/itcb54353390
  const root = create({version: '1.0', encoding: 'UTF-8'});

  const rss = root.ele('rss', {
    'xmlns:itunes': 'http://www.itunes.com/dtds/podcast-1.0.dtd',
    version: '2.0',
  });

  const channel = rss.ele('channel');
  channel.ele('title').txt('FeedShare');
  channel.ele('link').txt('https://feed.buechele.cc/');
  channel
    .ele('itunes:subtitle')
    .txt('Podcast episodes receommended by your friends');
  channel.ele('itunes:block').txt('yes');
  channel.ele('language').txt('en-us');
  channel.ele('itunes:author').txt('FeedShare');
  channel
    .ele('description')
    .txt(
      'Your personal feed of podcast episodes recommended by your friends on FeedShare.',
    );
  channel
    .ele('copyright')
    .txt('All rights belong to the respective owners of each episode.');
  channel.ele('itunes:image', {href: '...'});

  for (const share of shares) {
    const item = channel.ele('item');

    item
      .ele('title')
      .txt(
        `${share.author.handle}: ${share.episode.title} – ${share.episode.podcast.title}`,
      );
    item.ele('enclosure', {
      url: share.episode.enclosureUrl,
      length: share.episode.enclosureLength,
      type: share.episode.enclosureType,
    });
    item.ele('guid').txt(String(share.episode.id));
    item.ele('description').txt([``, share.episode.description].join('\n\n'));

    if (share.episode.durationSeconds) {
      item.ele('itunes:duration').txt(String(share.episode.durationSeconds));
    }

    if (share.episode.url) {
      item.ele('link').txt(share.episode.url);
    }

    if (share.episode.podcast.artwork) {
      item.ele('itunes:image').txt(share.episode.podcast.artwork);
    }
  }

  // convert the XML tree to string
  const xml = root.end({prettyPrint: true});
  res.type('xml').send(xml);
};

export default requestHandler;
