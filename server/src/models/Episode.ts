import {Episode} from '@prisma/client';
import TurndownService from 'turndown';
import {objectType} from 'nexus';
import imageField from '../utils/imageField';
import Node from './Node';
import {decodeHTML} from 'entities';
import {Episode as E} from 'nexus-prisma';

const turndownService = new TurndownService({});

export default objectType({
  name: 'Episode',
  definition(t) {
    t.implements(Node);

    t.field(E.title);
    t.field('description', {
      type: 'String',
      resolve: async (root) =>
        parseDescription((root as Episode).description ?? ''),
    });
    t.field(E.podcast);
    t.field(E.durationSeconds);
    t.field(E.datePublished);
    t.field(E.url);
    imageField(t, 'artwork');
  },
});

export function parseDescription(value: string): string {
  if (/<\/?[a-z][\s\S]*>/i.test(value)) {
    // has HTML
    value = turndownService.turndown(value);
  } else {
    // replace single linebreaks with <br />, following commonmark spec
    value = value.replace(/(?<!\n)\n(?!\n)/g, '\\\n');
  }

  return decodeHTML(value)
    .replace(
      /(\]\()?((https?:\/\/)?[a-z-0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b[-a-z0-9@:%_\+.~#?&\/\/=]*)(\))?/gim,
      (match, p1, p2, p3, p4, offset, str) => {
        // do not linkify
        if (p1 != null && p4 != null) {
          return match;
        } else if (
          str[offset - 1] === '[' &&
          str.substr(offset + match.length, 2) === ']('
        ) {
          // URL inside a link that is already parsed
          return match;
        }
        return `[${p2}](${p3 == null ? 'http://' : ''}${p2})${p4 ?? ''}`;
      },
    )
    .trim();
}
