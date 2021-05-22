import {parseDescription} from '../Episode';

describe('parseDescription', () => {
  it('converts html to markdown', () => {
    expect(parseDescription('test <a href="http://google.com">link</a>')).toBe(
      'test [link](http://google.com)',
    );
  });

  it('parses links in plain text', () => {
    expect(parseDescription('test google.com')).toBe(
      'test [google.com](http://google.com)',
    );
  });

  it('parses links in parenthesis', () => {
    expect(parseDescription('test (google.com)')).toBe(
      'test ([google.com](http://google.com))',
    );
  });

  it('does not double linkify', () => {
    expect(
      parseDescription('test <a href="http://google.com">goo.com</a>'),
    ).toBe('test [goo.com](http://google.com)');
  });

  it('converts single line breaks into br', () => {
    expect(parseDescription('test\ntest')).toBe('test\\\ntest');
  });
});
