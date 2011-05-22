/* DO NOT MODIFY. This file was compiled Sun, 22 May 2011 11:52:21 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map.coffee
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
  Map.events = Map.events || {};
  Map.events.init = function() {
    $("#map").bind("click", Map.events.click);
    $("#map").bind("dblclick", Map.events.dblclick);
    $("#map").bind("mousedown", Map.events.mousedown);
    $("#map").bind("mousemove", Map.events.mousemove);
    $(document).bind("mouseup", this.mouseup);
    return $(window).resize(Map.events.resize);
  };
  Map.events.click = function(e) {
    var position;
    position = Map.bar.position(e);
    return Map.bar.populate(position);
  };
  Map.events.dblclick = function(e) {
    Map.zoomIn();
    return Map.bar.position(e);
  };
  Map.events.mousedown = function(e) {
    Map.drag.start(e);
    Map.viewport.moveCursor();
    return false;
  };
  Map.events.mousemove = function(e) {
    if (Map.drag.dragging) {
      Map.drag.move(e);
      Map.viewport.moveDelta(Map.drag.dragDeltaLeft, Map.drag.dragDeltaTop, true);
    }
    return Map.bar.position(e);
  };
  Map.events.mouseup = function(e) {
    if (Map.drag.dragging) {
      Map.drag.end();
    }
    return Map.viewport.clearCursor();
  };
  Map.events.resize = function() {
    $("#map_viewport").width($(window).width() - $("#map_bar").width());
    $("#map_viewport").height($(window).height());
    $("#map").offset({
      left: $(window).width() - $("#map_viewport").width()
    });
    $("#map_bar").height($("#map_viewport").height());
    $("#map_bar").width($(window).width() - $("#map_viewport").width());
    return $("#map_position").offset({
      top: $("#map_bar").height()
    });
  };
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
  Map.viewport = Map.viewport || {};
  Map.viewport.init = function() {
    return Map.viewport.animateMove = true;
  };
  Map.viewport.top = function() {
    return $("#map_viewport").offset().top;
  };
  Map.viewport.left = function() {
    return $("#map_viewport").offset().left;
  };
  Map.viewport.moveCursor = function() {
    return $("#map_viewport").css("cursor", "move");
  };
  Map.viewport.clearCursor = function() {
    return $("#map_viewport").css("cursor", "");
  };
  Map.viewport.moveDelta = function(dLeft, dTop, noAnimate) {
    var left, top;
    left = this.left();
    top = this.top();
    left += dLeft;
    top += dTop;
    console.log("new vals", left, top);
    if (this.animateMove && !noAnimate) {
      $("#map_viewport").animate({
        left: left,
        top: top
      });
    } else {
      $("#map_viewport").offset({
        left: left,
        top: top
      });
    }
    Map.checkBounds();
    Map.layers.checkAll();
    return console.log(this.left(), this.top());
  };
  Map.bar = Map.bar || {};
  Map.bar.init = function() {};
  Map.bar.populate = function(position) {
    if (position.x > 0 && position.y > 0 && position.x <= Map.mapSize && position.y <= Map.mapSize) {
      if (this.ajax_request != null) {
        this.ajax_request.abort();
      }
      return this.ajax_request = $.ajax({
        type: "GET",
        url: "?q=map_click/" + Math.floor(position.x) + '/' + Math.floor(position.y),
        success: function(data) {
          $('#map_data').html(data);
          return $(window).triggerHandler('resize');
        }
      });
    }
  };
  Map.bar.position = function(e) {
    var displacementX, displacementY, offset, position, x_val, y_val;
    displacementX = $("#map_bar").width();
    displacementY = 0;
    offset = $("#map_viewport").offset();
    offset.left -= displacementX;
    offset.top -= displacementY;
    x_val = e.pageX - displacementX - offset.left;
    y_val = e.pageY - displacementY - offset.top;
    x_val = Math.ceil(x_val / Map.coordinateLength());
    y_val = Math.ceil(y_val / Map.coordinateLength());
    position = {
      x: x_val,
      y: y_val
    };
    $("#map_position").html(position.x + ", " + position.y);
    return position;
  };
  Map.drag = Map.drag || {};
  Map.dragging = false;
  Map.drag.start = function(e) {
    this.dragStartLeft = e.clientX;
    this.dragStartTop = e.clientY;
    return this.dragging = true;
  };
  Map.drag.move = function(e) {
    this.dragEndLeft = e.clientX;
    this.dragEndTop = e.clientY;
    this.dragDeltaLeft = this.dragEndLeft - this.dragStartLeft;
    this.dragDeltaTop = this.dragEndTop - this.dragStartTop;
    this.dragStartLeft = this.dragEndLeft;
    this.dragStartTop = this.dragEndTop;
    return Map.checkBounds();
  };
  Map.drag.end = function() {
    this.dragging = false;
    Map.checkBounds();
    return Map.layers.checkAll();
  };
  window.Map = Map;
}).call(this);
