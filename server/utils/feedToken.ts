import {ProvidedRequiredArgumentsOnDirectivesRule} from 'graphql/validation/rules/ProvidedRequiredArgumentsRule';

const ALPHABET =
  'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const LENGTH = 6;

export default function () {
  return Array.apply(null, Array(LENGTH))
    .map(() => ALPHABET.charAt(Math.floor(Math.random() * ALPHABET.length)))
    .join('');
}
