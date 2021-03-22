import fs from 'fs';
import https from 'https';
import {tmpdir} from 'os';
import {join} from 'path';
import decompress from 'decompress';
// @ts-ignore
import decompressTargz from 'decompress-targz';

export default async function () {
  const tmp = tmpdir();
  const tgzFile = join(tmp, 'podcastindex_feeds.db.tgz');
  const dbFile = join(tmp, 'podcastindex_feeds.db');
  const tgz = await download(
    tgzFile,
    'https://cloudflare-ipfs.com/ipns/k51qzi5uqu5dkde1r01kchnaieukg7xy9i6eu78kk3mm3vaa690oaotk1px6wo/podcastindex_feeds.db.tgz',
  );
  console.log('start decompress');

  const a = await decompress(tgzFile, dbFile, {
    plugins: [decompressTargz()],
  });
  console.log(a);
}

async function download(filename: string, url: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(filename);
    const request = https.get(url, (response) => response.pipe(file));

    request.on('finish', () => {
      resolve();
    });

    request.on('error', (e) => reject(e));
  });
}
