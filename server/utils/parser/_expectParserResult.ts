import {Parser, ParserResult} from '../../graphql/queries/resolveShareUrl';
import URL from 'url';

export default async (parser: Parser, tests: [string, ParserResult][]) => {
  for (const [url, result] of tests) {
    it(url, async () => {
      const res = await parser(URL.parse(url));
      expect(res).toEqual(result);
    });
  }
};
