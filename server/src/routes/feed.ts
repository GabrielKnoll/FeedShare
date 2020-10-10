// import {server} from '@nexus';
// import {create} from 'xmlbuilder2';

// server.express.route('/feed').get((req, res) => {
//   const root = create({version: '1.0'})
//     .ele('root', {att: 'val'})
//     .ele('foo')
//     .ele('bar')
//     .txt('foobar')
//     .up()
//     .up()
//     .ele('baz')
//     .up()
//     .up();

//   // convert the XML tree to string
//   const xml = root.end({prettyPrint: true});

//   res.type('xml').send(xml);
// });
