/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 14:07:49 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/map.coffee
 */

(function() {
  Game.map = Game.map || {};
  Game.map.init = function() {
    Game.map.maxTiles = 0;
    Game.map.tileSize = 256;
    Game.map.mapSize = 512;
    Game.map.defaultZoom = 3;
    Game.map.borderCache = 1;
    Game.map.layers.init();
    Game.map.events.init();
    Game.map.viewport.init();
    Game.map.resetZoom();
    window.setInterval(Game.map.events.resize, '100');
    window.setInterval(Game.map.events.resize, '2000');
    Game.map.checkBounds();
    return Game.map.layers.checkAll();
  };
  Game.map.coordinateLength = function() {
    return Math.pow(2, this.zoom);
  };
  Game.map.resetZoom = function() {
    var zoom;
    zoom = Game.map.defaultZoom;
    return this.setZoom(zoom);
  };
  Game.map.setZoom = function(z) {
    var totalSize;
    if (z < 0) {
      z = 0;
    } else if (z > 7) {
      z = 7;
    }
    this.zoom = z;
    totalSize = this.mapSize * this.coordinateLength();
    Game.map.maxTiles = totalSize / this.tileSize;
    $("#map_viewport").width(totalSize);
    $("#map_viewport").height(totalSize);
    return this.layers.checkAll();
  };
  Game.map.zoomIn = function() {
    this.setZoom(this.zoom - 1);
    return console.log("New zoom: ", this.zoom);
  };
  Game.map.zoomOut = function() {
    this.setZoom(this.zoom + 1);
    return console.log("New zoom: ", this.zoom);
  };
  Game.map.checkBounds = function() {
    var left_offset, top_offset, totalSize, viewport;
    viewport = $("#map_viewport");
    totalSize = this.mapSize * this.coordinateLength();
    left_offset = 0 + $("#map_bar").width();
    top_offset = 0;
    if (viewport.offset().left - left_offset > 0) {
      viewport.offset({
        left: left_offset
      });
    } else if (viewport.offset().left < viewport.width() - totalSize + left_offset) {
      viewport.offset({
        left: viewport.width() - totalSize + left_offset
      });
    }
    if (viewport.offset().top + top_offset > 0) {
      return viewport.offset({
        top: 0 + top_offset
      });
    } else if (viewport.offset().top < viewport.height() - totalSize + top_offset) {
      return viewport.offset({
        top: viewport.height() - totalSize + top_offset
      });
    }
  };
}).call(this);
