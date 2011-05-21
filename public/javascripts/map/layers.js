/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 19:54:20 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/layers.coffee
 */

(function() {
  var Map;
  Map = Map || {};
  Map.layers = Map.layers || {};
  Map.layers.init = function() {
    Map.layers.checkLock = false;
    return Map.layers.tilesets = Drupal.settings.tilesets;
  };
  Map.layers.checkAll = function() {
    var tileset, _i, _len, _ref;
    while (Map.layers.checkLock) {
      true;
    }
    if (!Map.layers.checkLock) {
      Map.layers.checkLock = true;
      _ref = Map.layers.tilesets;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tileset = _ref[_i];
        Map.layers.check(tileset);
      }
    }
    return Map.layers.checkLock = false;
  };
  Map.layers.check = function(type) {
    var fetch, fetchTiles, tile, tileArr, url, visTiles, visTilesMap, _fn, _i, _j, _len, _len2;
    visTiles = Map.layers.getVisibleTiles();
    visTilesMap = new Array();
    fetchTiles = new Array();
    _fn = function() {
      var cached, tileName;
      tileName = type + '-' + tileArr.xPos + '-' + tileArr.yPos + '-' + Map.zoom;
      visTilesMap[tileName] = tileArr;
      $("#" + tileName).remove();
      cached = $("#map_viewport").data(tileName);
      if ((cached != null) && (cached.html != null)) {
        return $("#map_viewport").append(cached.html);
      } else {
        return fetchTiles.push(tileName);
      }
    };
    for (_i = 0, _len = visTiles.length; _i < _len; _i++) {
      tileArr = visTiles[_i];
      _fn();
    }
    url = Drupal.settings.basePath + "?q=tiles";
    fetch = false;
    for (_j = 0, _len2 = fetchTiles.length; _j < _len2; _j++) {
      tile = fetchTiles[_j];
      url = url + "&tiles[]=" + encodeURIComponent(fetchTiles[tile]);
      fetch = true;
    }
    if (fetch) {
      $.getJSON(url, function(data) {
        if (data != null) {
          return $.each(data(function(index, value) {
            if ((value != null) && (value.html != null)) {
              $("#map_viewport").append(value.html);
              return $("#map_viewport").data(index(value));
            }
          }));
        }
      }, "json");
    }
    return $(window).triggerHandler('resize');
  };
  Map.layers.clear = function(type) {
    return $("#map_viewport img").each(function(i) {
      if ($(this).hasClass(type)) {
        return $(this).remove();
      }
    });
  };
  Map.layers.clearAll = function() {
    var tileset, _i, _len, _ref, _results;
    _ref = Map.layers.tilesets;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tileset = _ref[_i];
      _results.push(Map.layers.clear(tileset));
    }
    return _results;
  };
  Map.layers.getVisibleTiles = function() {
    var counter, endX, endY, mapX, mapY, startX, startY, tilesX, tilesY, visibleTiles, x, _fn;
    mapX = Map.viewport.left();
    mapY = Map.viewport.top();
    startX = Math.abs(Math.floor(mapX / Map.tileSize)) - Map.borderCache;
    startY = Math.abs(Math.floor(mapY / Map.tileSize)) - Map.borderCache;
    startX = Math.max(0, startX);
    startY = Math.max(0, startY);
    tilesX = Math.ceil($("#map_viewport").width() / Map.tileSize) + Map.borderCache;
    tilesY = Math.ceil($("#map_viewport").height() / Map.tileSize) + Map.borderCache;
    endX = startX + tilesX;
    endY = startY + tilesY;
    endX = Math.min(Map.maxTiles - 1, endX);
    endY = Math.min(Map.maxTiles - 1, endY);
    visibleTiles = [];
    counter = 0;
    _fn = function() {
      var y, _results;
      _results = [];
      for (y = startY; startY <= endY ? y <= endY : y >= endY; startY <= endY ? y++ : y--) {
        _results.push((function() {
          var tile;
          tile = {
            xPos: x,
            yPos: y
          };
          return visibleTiles[counter++] = tile;
        })());
      }
      return _results;
    };
    for (x = startX; startX <= endX ? x <= endX : x >= endX; startX <= endX ? x++ : x--) {
      _fn();
    }
    return visibleTiles;
  };
}).call(this);
