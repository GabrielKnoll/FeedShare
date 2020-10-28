import {create} from 'xmlbuilder2';
import {RequestHandler} from 'express';

const requestHandler: RequestHandler<{
  handle: string;
}> = (req, res) => {
  const root = create({version: '1.0'})
    .ele('root', {att: 'val'})
    .ele('foo')
    .ele('bar')
    .txt(req.params.handle)
    .up()
    .up()
    .ele('baz')
    .up()
    .up();

  // convert the XML tree to string
  const xml = root.end({prettyPrint: true});

  res.type('xml').send(xml);
};

export default requestHandler;
