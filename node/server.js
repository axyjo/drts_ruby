var http = require('http'),
    fs   = require('fs'),
    im   = require('imagemagick'),
    faye = require('faye');

var bayeux = new faye.NodeAdapter({
    mount:    '/faye',
    timeout:  45
});

var server = http.createServer(function(req, res) {
  var segments = require('url').parse(req.url).pathname;
  segments = segments.split('/');

  if(segments.length == 5) {
    var maxZoom = 3;
    var sliceSize = 2048;
    // We're dealing with tiles.
    try {
      var type = segments[1];
      var z    = parseInt(segments[2]);
      var x    = parseInt(segments[3]);
      var y    = parseInt(segments[4]);

      // Check if directory exists.
      var dir = fs.lstatSync(type);

      if(z >= 0 && z <= maxZoom) {
        var scale = Math.pow(2, z-maxZoom);
        // Chunk count is the number of chunks in the tile at the current zoom.
        var chunkCount = Math.pow(2, z);

        // Calculate which pre-cut tile will contain what we want.
        var tileX = Math.floor(x/chunkCount).toString();
        var tileY = Math.floor(y/chunkCount).toString();

        // Calculate how much of the pre-cut tile we want.
        var chunkWidth = sliceSize/chunkCount;
        var chunkHeight = sliceSize/chunkCount;
        var chunkX = (x % chunkCount) * chunkWidth;
        var chunkY = (y % chunkCount) * chunkHeight;

        var imgPath = require('path').join(type, tileX, tileY) + '.png';
        var crop = chunkWidth +'x'+ chunkHeight +'+'+ chunkX +'+'+ chunkY;
        var options = ['-crop', crop, '+repage', '-scale', '256x256', 'png:-'];

        require('path').exists(imgPath, function(exists) {
          if(exists) {
            res.writeHead(200, {'Content-Type': 'image/png'});
            im.convert(options, function(err, stdout) {
              res.end(stdout);
            });
          } else {
            throw new Error('imgPath does not exist: '+imgPath);
          }
        });
      } else {
        throw new Error('Zoom-level is out of bounds.');
      }
    } catch (e) {
      res.writeHead(500, {'Content-Type': 'text/plain'});
      res.end(e.message);
    }
  }
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end("Leave me alone!");
});

bayeux.attach(server);
server.listen(8080);
