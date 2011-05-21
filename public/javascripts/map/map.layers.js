/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 14:28:48 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/map.layers.coffee
 */

(function() {
  Game.map.layers = Game.map.layers || {};
  Game.map.layers.init = function() {
    Game.map.layers.checkLock = false;
    return Game.map.layers.tilesets = Drupal.settings.tilesets;
  };
  Game.map.layers.checkAll = function() {
    var tileset, _i, _len, _ref;
    while (Game.map.layers.checkLock) {
      true;
    }
    if (!Game.map.layers.checkLock) {
      Game.map.layers.checkLock = true;
      _ref = Game.map.layers.tilesets;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tileset = _ref[_i];
        Game.map.layers.check(tileset);
      }
    }
    return Game.map.layers.checkLock = false;
  };
  Game.map.layers.check = function(type) {
    var fetch, fetchTiles, tile, tileArr, url, visTiles, visTilesMap, _fn, _i, _j, _len, _len2;
    visTiles = Game.map.layers.getVisibleTiles();
    visTilesMap = new Array();
    fetchTiles = new Array();
    _fn = function() {
      var cached, tileName;
      tileName = type + '-' + tileArr.xPos + '-' + tileArr.yPos + '-' + Game.map.zoom;
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
  Game.map.layers.clear = function(type) {
    return $("#map_viewport img").each(function(i) {
      if ($(this).hasClass(type)) {
        return $(this).remove();
      }
    });
  };
  Game.map.layers.clearAll = function() {
    var tileset, _i, _len, _ref, _results;
    _ref = Game.map.layers.tilesets;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tileset = _ref[_i];
      _results.push(Game.map.layers.clear(tileset));
    }
    return _results;
  };
  Game.map.layers.getVisibleTiles = function() {
    var counter, endX, endY, mapX, mapY, startX, startY, tilesX, tilesY, visibleTiles, x, _fn;
    mapX = Game.map.viewport.left();
    mapY = Game.map.viewport.top();
    startX = Math.abs(Math.floor(mapX / Game.map.tileSize)) - Game.map.borderCache;
    startY = Math.abs(Math.floor(mapY / Game.map.tileSize)) - Game.map.borderCache;
    startX = Math.max(0, startX);
    startY = Math.max(0, startY);
    tilesX = Math.ceil($("#map_viewport").width() / Game.map.tileSize) + Game.map.borderCache;
    tilesY = Math.ceil($("#map_viewport").height() / Game.map.tileSize) + Game.map.borderCache;
    endX = startX + tilesX;
    endY = startY + tilesY;
    endX = Math.min(Game.map.maxTiles - 1, endX);
    endY = Math.min(Game.map.maxTiles - 1, endY);
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
