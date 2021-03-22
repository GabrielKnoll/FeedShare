import dotEnv from 'dotenv';
dotEnv.config();

import sqlite from 'better-sqlite3';
import prismaClient from '../src/utils/prismaClient';

type PodcastImportRow = {
  id: string;
  url: string;
  title: string;
  lastUpdate: string;
  link: string;
  lastHttpStatus: string;
  dead: string;
  contentType: string;
  itunesId: string;
  originalUrl: string;
  itunesAuthor: string;
  itunesOwnerName: string;
  explicit: string;
  imageUrl: string;
  itunesType: string;
  generator: string;
  newestItemPubdate: string;
  language: string;
  oldestItemPubdate: string;
  episodeCount: string;
  popularityScore: string;
};

const BATCH_SIZE = 5000;
const db = sqlite('/Users/danielbuechele/Downloads/podcastindex_feeds 2.db', {
  readonly: true,
});

let offset = 0;

(async () => {
  console.log('Starting import...');

  // https://cloudflare-ipfs.com/ipns/k51qzi5uqu5dkde1r01kchnaieukg7xy9i6eu78kk3mm3vaa690oaotk1px6wo/podcastindex_feeds.db.tgz

  // const deleteDuplicates = db.prepare('DELETE FROM podcasts WHERE id IN (SELECT id FROM podcasts t WHERE itunesId != "" GROUP BY t.itunesId HAVING COUNT(t.itunesId) > 1);');

  const statement = db.prepare<[number, number]>(
    'SELECT * FROM Podcasts LIMIT ? OFFSET ?',
  );

  while (true) {
    const podcasts: PodcastImportRow[] = statement.all(BATCH_SIZE, offset);

    if (podcasts.length === 0) {
      break;
    }

    const data = podcasts.map(
      (p) =>
        `(${p.id}, ${sanitize(p.itunesId)}, '${sanitize(
          p.itunesAuthor,
        )}', '${sanitize(p.title)}', '${sanitize(p.imageUrl)}')`,
    );

    console.log(`Batch ${offset}`);

    try {
      await prismaClient.$executeRaw(`
      INSERT INTO "Podcast"("id", "itunesId", "publisher", "title", "artwork")
      VALUES ${data.join(',')}
      ON CONFLICT ("id") DO UPDATE SET (publisher, title, artwork) = (EXCLUDED.publisher, EXCLUDED.title, EXCLUDED.artwork)
      `);
    } catch (e) {
      console.error(e);
      if (e.code === 'P2010') {
        // connection closed -> reconnect?
        await prismaClient.$connect();
      } else {
        break;
      }
    }
    offset += BATCH_SIZE;
  }

  console.log(`Done!`);

  await prismaClient.$disconnect();

  process.exit(0);
})();

function sanitize(input: string) {
  if (!input) {
    return 'NULL';
  }
  return String(input).replace(/'/g, "''");
}
