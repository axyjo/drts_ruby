/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 15:30:42 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/viewport.coffee
 */

(function() {
  Game.map.viewport = Game.map.viewport || {};
  Game.map.viewport.init = function() {
    return Game.map.viewport.animateMove = true;
  };
  Game.map.viewport.top = function() {
    return $("#map_viewport").offset().top;
  };
  Game.map.viewport.left = function() {
    return $("#map_viewport").offset().left;
  };
  Game.map.viewport.moveCursor = function() {
    return $("#map_viewport").css("cursor", "move");
  };
  Game.map.viewport.clearCursor = function() {
    return $("#map_viewport").css("cursor", "");
  };
  Game.map.viewport.moveDelta = function(dLeft, dTop, noAnimate) {
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
    Game.map.checkBounds();
    Game.map.layers.checkAll();
    return console.log(this.left(), this.top());
  };
}).call(this);
