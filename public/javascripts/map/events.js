/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 19:54:21 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/events.coffee
 */

(function() {
  var Map;
  Map = Map || {};
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
}).call(this);
