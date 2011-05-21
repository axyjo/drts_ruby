/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 19:54:21 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/viewport.coffee
 */

(function() {
  var Map;
  Map = Map || {};
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
}).call(this);
