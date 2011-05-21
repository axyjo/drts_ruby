/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 14:28:48 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/map.events.coffee
 */

(function() {
  Game.map.events = Game.map.events || {};
  Game.map.events.init = function() {
    $("#map").bind("click", Game.map.events.click);
    $("#map").bind("dblclick", Game.map.events.dblclick);
    $("#map").bind("mousedown", Game.map.events.mousedown);
    $("#map").bind("mousemove", Game.map.events.mousemove);
    $(document).bind("mouseup", this.mouseup);
    return $(window).resize(Game.map.events.resize);
  };
  Game.map.events.click = function(e) {
    var position;
    position = Game.map.bar.position(e);
    return Game.map.bar.populate(position);
  };
  Game.map.events.dblclick = function(e) {
    Game.map.zoomIn();
    return Game.map.bar.position(e);
  };
  Game.map.events.mousedown = function(e) {
    Game.map.drag.start(e);
    Game.map.viewport.moveCursor();
    return false;
  };
  Game.map.events.mousemove = function(e) {
    if (Game.map.drag.dragging) {
      Game.map.drag.move(e);
      Game.map.viewport.moveDelta(Game.map.drag.dragDeltaLeft, Game.map.drag.dragDeltaTop, true);
    }
    return Game.map.bar.position(e);
  };
  Game.map.events.mouseup = function(e) {
    if (Game.map.drag.dragging) {
      Game.map.drag.end();
    }
    return Game.map.viewport.clearCursor();
  };
  Game.map.events.resize = function() {
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
}).call(this);
