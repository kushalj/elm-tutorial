const jsonServer = require('json-server');
const server = jsonServer.create();
const port = 8000;

server.use(jsonServer.defaults());

const router = jsonServer.router('db.json');
server.use(router);

console.log('listening at http://localhost:'+port);
server.listen(port);
