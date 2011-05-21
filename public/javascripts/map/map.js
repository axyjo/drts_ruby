/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 19:54:20 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/map.coffee
 */

(function() {
  var Map;
  Map = Map || {};
  Map.init = function() {
    Map.maxTiles = 0;
    Map.tileSize = 256;
    Map.mapSize = 512;
    Map.defaultZoom = 3;
    Map.borderCache = 1;
    Map.layers.init();
    Map.events.init();
    Map.viewport.init();
    Map.resetZoom();
    window.setInterval(Map.events.resize, '100');
    window.setInterval(Map.events.resize, '2000');
    Map.checkBounds();
    return Map.layers.checkAll();
  };
  Map.coordinateLength = function() {
    return Math.pow(2, this.zoom);
  };
  Map.resetZoom = function() {
    var zoom;
    zoom = Map.defaultZoom;
    return this.setZoom(zoom);
  };
  Map.setZoom = function(z) {
    var totalSize;
    if (z < 0) {
      z = 0;
    } else if (z > 7) {
      z = 7;
    }
    this.zoom = z;
    totalSize = this.mapSize * this.coordinateLength();
    Map.maxTiles = totalSize / this.tileSize;
    $("#map_viewport").width(totalSize);
    $("#map_viewport").height(totalSize);
    return this.layers.checkAll();
  };
  Map.zoomIn = function() {
    this.setZoom(this.zoom - 1);
    return console.log("New zoom: ", this.zoom);
  };
  Map.zoomOut = function() {
    this.setZoom(this.zoom + 1);
    return console.log("New zoom: ", this.zoom);
  };
  Map.checkBounds = function() {
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
