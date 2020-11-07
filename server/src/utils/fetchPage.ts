import fetch from 'node-fetch';
import cheerio from 'cheerio';
import URL from 'url';

export default async function fetchPage(url: URL.UrlWithStringQuery) {
  const pageContent = await fetch(url).then((res) => res.text());
  return cheerio.load(pageContent);
}
