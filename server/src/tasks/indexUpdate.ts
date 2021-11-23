import {tmpdir} from 'os';
import {join} from 'path';
import got from 'got';
import {createWriteStream, createReadStream, unlinkSync} from 'fs';
import stream from 'stream';
import {promisify} from 'util';
import tar from 'tar';
import sqlite from 'better-sqlite3';
import {JobHelpers} from 'graphile-worker';

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

const pipeline = promisify(stream.pipeline);

const URL =
  'https://cloudflare-ipfs.com/ipns/k51qzi5uqu5dkde1r01kchnaieukg7xy9i6eu78kk3mm3vaa690oaotk1px6wo/podcastindex_feeds.db.tgz';
const BATCH_SIZE = 5000;

export default async function (
  _payload: undefined,
  {logger, withPgClient}: JobHelpers,
) {
  const {
    rows: [lastImport = {value: '0'}],
  } = await withPgClient((pgClient) =>
    pgClient.query<{value: string}>(
      `SELECT value FROM "Config" WHERE key='LastIndexImport'`,
    ),
  );

  const tmp = tmpdir();
  const tgzFile = join(tmp, 'podcastindex_feeds.db.tgz');
  const dbFile = join(tmp, 'podcastindex_feeds.db');

  try {
    // delete if file exists
    unlinkSync(tgzFile);
  } catch (e) {}

  logger.info(`Starting download to ${tgzFile}`);
  const downloadStream = got.stream(URL);
  const fileWriterStream = createWriteStream(tgzFile).on(
    'downloadProgress',
    ({
      transferred,
      total,
      percent,
    }: {
      transferred: number;
      total: number;
      percent: number;
    }) => {
      logger.error(
        `progress: ${transferred}/${total} (${Math.round(percent * 100)}%)`,
      );
    },
  );

  await pipeline(downloadStream, fileWriterStream);

  try {
    unlinkSync(dbFile);
  } catch (e) {}

  logger.info(`downloaded to ${tgzFile}. Starting decompression...`);

  await new Promise<void>((resolve, reject) =>
    createReadStream(tgzFile)
      .pipe(
        tar.x({
          strip: 1,
          cwd: tmp,
        }),
      )
      .on('finish', () => resolve())
      .on('error', (e) => reject(e)),
  );

  logger.info(`Extracted database`);
  unlinkSync(tgzFile);

  const db = sqlite(dbFile, {
    readonly: true,
  });

  logger.info('Starting import...');
  const statement = db.prepare<[number, number]>(
    `SELECT * FROM Podcasts WHERE lastUpdate > ${lastImport.value} LIMIT ? OFFSET ?`,
  );
  let offset = 0;

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

    logger.info(`Batch ${offset}`);

    try {
      await withPgClient((pgClient) =>
        pgClient.query(`
        INSERT INTO "Podcast"("id", "itunesId", "publisher", "title", "artwork")
        VALUES ${data.join(',')}
        ON CONFLICT ("id") DO UPDATE SET (publisher, title, artwork) = (EXCLUDED.publisher, EXCLUDED.title, EXCLUDED.artwork)
        `),
      );
    } catch (e: any) {
      logger.error(e);
      throw e;
    }

    offset += BATCH_SIZE;
  }

  if (offset > 0) {
    const lastUpdate: string = db
      .prepare(
        `SELECT MAX(lastUpdate) FROM "podcasts" WHERE lastUpdate < strftime('%s', 'now');`,
      )
      .pluck()
      .get();

    await withPgClient((pgClient) =>
      pgClient.query(`
        INSERT INTO "Config"("key", "value")
        VALUES ('LastIndexImport', ${lastUpdate})
        ON CONFLICT ("key") DO UPDATE SET "value" = EXCLUDED.value;
      `),
    );
  }

  logger.info(`Done!`);

  unlinkSync(dbFile);
}

function sanitize(input: string) {
  if (!input) {
    return 'NULL';
  }
  return String(input).replace(/'/g, "''");
}
