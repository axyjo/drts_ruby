var http = require('http'),
    fs   = require('fs'),
    faye = require('./faye');

var bayeux = new faye.NodeAdapter({
    mount:    '/faye',
    timeout:  45
});

var server = http.createServer(function(req, res) {
    var segments = require('url').parse(req.url).pathname;
    segments = segments.split('/').splice(1, 4);

    try {
      var dir = fs.lstatSync(segments[0]);
      res.WriteHead(200, {'Content-Type': 'image/png'});
      res.end('Hello World\n');
    } catch (e) {
      res.WriteHead(200, {'Content-Type': 'text/plain'});
      res.end(e);
    }
});

bayeux.attach(server);
server.listen(8080);
