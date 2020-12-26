import {create} from 'xmlbuilder2';
import prismaClient from '../../../utils/prismaClient';
import {shareWhere} from '../../../graphql/models/Share';
import {NextApiRequest, NextApiResponse} from 'next';
import {gql} from 'graphql-request';
import datoCMS from '../../../utils/datoCMS';

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

const requestHandler = async (req: NextApiRequest, res: NextApiResponse) => {
  const {token} = req.query;
  if (typeof req.query.token !== 'string') {
    throw new Error('Missing token.');
  }

  const {feed} = await datoCMS.Feed();

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
  channel.ele('title').txt(feed?.title ?? '');
  channel.ele('link').txt(process.env.BASE_URL);
  channel.ele('itunes:subtitle').txt(feed?.subtitle ?? '');
  channel.ele('itunes:block').txt('yes');
  channel.ele('language').txt('en-us');
  channel.ele('itunes:author').txt(feed?.author ?? '');
  channel.ele('description').txt(feed?.description ?? '');
  channel.ele('copyright').txt(feed?.copyright ?? '');
  channel.ele('itunes:image', {href: feed?.artwork?.url ?? ''});

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
  res.setHeader('Content-Type', 'application/rss+xml');
  res.send(xml);
};

export default requestHandler;
