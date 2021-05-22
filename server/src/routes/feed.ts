import {create} from 'xmlbuilder2';
import prismaClient from '../utils/prismaClient';
import {Request, Response} from 'express';
import {gql} from 'graphql-request';
import env from '../utils/env';
import imagekit from '../utils/imagekit';
import {personalFeedShares} from '../queries/shares';

gql`
  query Feed {
    feed {
      title
      description
      copyright
      author
      subtitle
      artwork {
        id
        url(imgixParams: {w: 600, fm: jpg})
      }
    }
  }
`;

const requestHandler = async (req: Request, res: Response) => {
  const {token} = req.params;

  const user = await prismaClient.user.update({
    data: {
      feedCheckedAt: new Date(),
    },
    where: {
      feedToken: String(token),
    },
    include: {
      twitterAccount: true,
    },
  });

  const shareIds = await personalFeedShares(
    prismaClient,
    false,
    user.id,
    50,
    0,
  ).then((s) => s.map((s) => s.id));

  const shares = await prismaClient.share.findMany({
    include: {
      episode: {
        include: {
          podcast: true,
        },
      },
      author: true,
    },
    where: {
      id: {
        in: shareIds,
      },
    },
  });

  shares.sort((a, b) => shareIds.indexOf(a.id) - shareIds.indexOf(b.id));

  // https://help.apple.com/itc/podcasts_connect/#/itcb54353390
  const root = create({version: '1.0', encoding: 'UTF-8'});

  const rss = root.ele('rss', {
    'xmlns:itunes': 'http://www.itunes.com/dtds/podcast-1.0.dtd',
    version: '2.0',
  });

  const channel = rss.ele('channel');
  channel.ele('title').txt('Truffle Recommendations');
  channel.ele('link').txt(env.BASE_URL);
  channel
    .ele('itunes:subtitle')
    .txt('Podcast episodes receommended by your friends');
  channel.ele('itunes:block').txt('yes');
  channel.ele('language').txt('en-us');
  channel.ele('itunes:author').txt('Truffle');
  channel
    .ele('description')
    .txt(
      'Your personal feed of podcast episodes recommended by your friends on Truffle.',
    );
  channel
    .ele('copyright')
    .txt('All rights belong to the respective owners of each episode.');

  channel.ele('itunes:image', {
    href: imagekit.url({
      signed: true,
      path: 'icon-1024_ui3vgUFFL.png',
    }),
  });

  for (let i = 0; i < shares.length; i++) {
    const share = shares[i];

    const item = channel.ele('item');

    item
      .ele('title')
      .txt(
        `${share.author.displayName}: ${share.episode.title} – ${share.episode.podcast.title}`,
      );
    item.ele('enclosure', {
      url: share.episode.enclosureUrl,
      length: share.episode.enclosureLength,
      type: share.episode.enclosureType,
    });
    item.ele('guid').txt(String(share.episode.id));
    item.ele('pubDate').txt(share.createdAt.toUTCString());
    item
      .ele('description')
      .txt(
        [
          `${share.author.displayName} shared this episode via FeedShare:\n${share.message}`,
          share.episode.description,
        ].join('\n\n'),
      );

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
  res.setHeader('Content-Type', 'application/rss+xml');
  res.send(xml);
};

export default requestHandler;
