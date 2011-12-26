var http = require('http'),
    fs   = require('fs'),
    path = require('path'),
    cache= require('./cache'),
    im   = require('imagemagick'),
    faye = require('faye');

var bayeux = new faye.NodeAdapter({
    mount:    '/faye',
    timeout:  45
});

var server = http.createServer(function(req, res) {
  var segments = require('url').parse(req.url).pathname;
  segments = segments.split('/');

  if(segments.length == 6 && segments[1] == 'tiles') {
    // We're dealing with tiles.
    try {
      var type = segments[2];
      var z    = parseInt(segments[3]);
      var x    = parseInt(segments[4]);
      var y    = parseInt(segments[5]);
      var tileID = type + '-' + z + '-' + x + '-' + y;

      // Check if directory exists.
      var dir = fs.lstatSync(type);

      var maxZoom = 7;
      var sliceSize = 2048;
      var tileSize = 256;
      if(z >= 0 && z <= maxZoom) {
        if(val = cache.get(tileID)) {
          res.writeHead(200, {
            'Content-Type': 'image/png',
            'Content-Length': val.length
          });
          res.end(val, 'binary');
        }
        var TTL = cache.getTTL(tileID);
        if(isNaN(TTL) || TTL < 60*1000 || !val) {
          var scale = Math.pow(2, z-(Math.log(sliceSize/tileSize)/Math.log(2));

          // The number of chunks in the tile at the current zoom.
          var chunkCount = Math.pow(2, z);
          if(scale >= 1) {
            // Calculate which pre-cut tile will contain what we want.
            var tileX = Math.floor(x/chunkCount).toString();
            var tileY = Math.floor(y/chunkCount).toString();

            // Calculate how much of the pre-cut tile we want.
            var chunkWidth = sliceSize/chunkCount;
            var chunkHeight = sliceSize/chunkCount;
            var chunkX = (x % chunkCount) * chunkWidth;
            var chunkY = (y % chunkCount) * chunkHeight;

            var imgPath = path.join(type, tileX, tileY) + '.png';
            path.exists(imgPath, function(exists) {
              if(exists) {
                var crop = chunkWidth +'x'+ chunkHeight +'+'+ chunkX +'+'+ chunkY;
                var op = [imgPath, '-crop', crop, '+repage', '-scale', '256x256', '-'];
                im.convert(op, function(err, stdout) {
                  if(err) throw err;
                  cache.put(tileID, stdout, 5*60*1000);
                  if(isNaN(TTL) || !val) {
                    res.writeHead(200, {
                      'Content-Type': 'image/png',
                      'Content-Length': stdout.length
                    });
                    res.end(stdout, 'binary');
                  }
                });
              } else {
                throw new Error('imgPath does not exist: '+imgPath);
              }
            });
          } else {
            var imagesToMerge = 1/scale;
            var startX = x * chunkCount;
            var startY = y * chunkCount;
            var endX = startX + imagesToMerge;
            var endY = startY + imagesToMerge;

            var topLeftPath = path.join(type, startX, startY) + '.png';
            var bottomRightPath = path.join(type, endX, endY) + '.png';

            path.exists(topLeftPath, function(exists) {
              if(exists) {
                path.exists(bottomRightPath, function(exists) {
                  if(exists) {
                    var op = [];
                    for(var a = startY; a < endY; a++) {
                      for(var b = startX; b < endX; b++) {
                        op.push(path.join(type, b, a) + '.png');
                      }
                    }

                    op.push('-mode', 'Concatenate', '-tile', '4x');
                    op.push('+repage', '-scale', '256x256', '-');
                    im.convert(op, function(err, stdout) {
                      if(err) throw err;
                      cache.put(tileID, stdout, 5*60*1000);
                      if(isNaN(TTL) || !val) {
                        res.writeHead(200, {
                          'Content-Type': 'image/png',
                          'Content-Length': stdout.length
                        });
                        res.end(stdout, 'binary');
                      }
                    });
                  }
                });
              }
            });
          }
        }
      } else {
        throw new Error('Zoom-level is out of bounds.');
      }
    } catch (e) {
      res.writeHead(500, {'Content-Type': 'text/plain'});
      res.end(e.message);
    }
  } else {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end("Hello, world! Welcome to <strong>zeus</strong>.");
  }
});

bayeux.attach(server);
server.listen(8080);
