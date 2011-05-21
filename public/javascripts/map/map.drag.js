/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 13:45:44 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/map.drag.coffee
 */

(function() {
  Game.map.drag = Game.map.drag || {};
  Game.map.dragging = false;
  Game.map.drag.start = function(e) {
    this.dragStartLeft = e.clientX;
    this.dragStartTop = e.clientY;
    return this.dragging = true;
  };
  Game.map.drag.move = function(e) {
    this.dragEndLeft = e.clientX;
    this.dragEndTop = e.clientY;
    this.dragDeltaLeft = this.dragEndLeft - this.dragStartLeft;
    this.dragDeltaTop = this.dragEndTop - this.dragStartTop;
    this.dragStartLeft = this.dragEndLeft;
    this.dragStartTop = this.dragEndTop;
    return Game.map.checkBounds();
  };
  Game.map.drag.end = function() {
    this.dragging = false;
    Game.map.checkBounds();
    return Game.map.layers.checkAll();
  };
}).call(this);
