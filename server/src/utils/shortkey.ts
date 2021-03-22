const ALPHABET =
  'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

export default function (length: number) {
  return Array.apply(null, Array(length))
    .map(() => ALPHABET.charAt(Math.floor(Math.random() * ALPHABET.length)))
    .join('');
}
