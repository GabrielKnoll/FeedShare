import env from './env';
import ImageKit from 'imagekit';

export const urlEndpoint = 'https://ik.imagekit.io/' + env.IMAGEKIT_ID;

export default new ImageKit({
  publicKey: env.IMAGEKIT_PUBLIC_KEY,
  privateKey: env.IMAGEKIT_PRIVATE_KEY,
  urlEndpoint,
});
