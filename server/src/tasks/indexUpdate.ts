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
  id: number;
  url: string;
  title: string;
  lastUpdate: number;
  link: string;
  lastHttpStatus: number;
  dead: number;
  contentType: string;
  itunesId: number;
  originalUrl: string;
  itunesAuthor: string;
  itunesOwnerName: string;
  explicit: number;
  imageUrl: string;
  itunesType: string;
  generator: string;
  newestItemPubdate: number;
  language: string;
  oldestItemPubdate: number;
  episodeCount: number;
  popularityScore: number;
  createdOn: number;
  updateFrequency: number;
  chash: string;
  host: string;
  newestEnclosureUrl: string;
  podcastGuid: string;
};

const pipeline = promisify(stream.pipeline);

const URL =
  'https://cloudflare-ipfs.com/ipns/k51qzi5uqu5dkde1r01kchnaieukg7xy9i6eu78kk3mm3vaa690oaotk1px6wo/podcastindex_feeds.db.tgz';
const BATCH_SIZE = 5000;

export default async function (
  _payload: undefined,
  {logger, withPgClient}: JobHelpers,
) {
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
    `SELECT * FROM podcasts WHERE
      episodeCount > 0 AND
      itunesAuthor IS NOT NULL AND TRIM(itunesAuthor) != '' AND
      title        IS NOT NULL AND TRIM(title       ) != ''
    LIMIT ? OFFSET ?`,
  );
  let offset = 0;

  const startTime = new Date();

  while (true) {
    const podcasts: PodcastImportRow[] = statement.all(BATCH_SIZE, offset);

    if (podcasts.length === 0) {
      break;
    }

    logger.info(`Batch ${offset}-${offset + podcasts.length}`);

    try {
      const numberInsertValues = 5;
      await withPgClient((pgClient) =>
        pgClient.query(
          `
        INSERT INTO "Podcast"("id", "itunesId", "publisher", "title", "artwork")
        VALUES ${podcasts
          .map(
            (_, i) =>
              `(${Array.from(Array(numberInsertValues))
                .map((_, j) => `$${i * numberInsertValues + j + 1}`)
                .join(',')})`,
          )
          .join(',')}
        ON CONFLICT ("id") DO UPDATE SET (publisher, title, artwork) = (EXCLUDED.publisher, EXCLUDED.title, EXCLUDED.artwork)
        `,
          podcasts.flatMap((p) => [
            p.id, // can't  be null, primary key
            !p.itunesId ? null : p.itunesId,
            p.itunesAuthor, // can't be null, checked in query
            p.title, // can't be null, checked in query
            !p.imageUrl ? null : p.imageUrl,
          ]),
        ),
      );
    } catch (e: any) {
      logger.error(e);
      throw e;
    }

    offset += BATCH_SIZE;
  }

  // Delete podcasts that don't exist anymore
  await withPgClient((pgClient) =>
    pgClient.query(
      `DELETE FROM "Podcast" p
       WHERE
          "updatedAt" at time zone current_setting('TIMEZONE') < $1 AND
          NOT EXISTS (SELECT FROM "Episode" WHERE "podcastId" = p.id);`,
      [startTime.toISOString()],
    ),
  );

  logger.info(`Done!`);

  unlinkSync(dbFile);
}
