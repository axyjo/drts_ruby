/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 19:54:20 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/drag.coffee
 */

(function() {
  var Map;
  Map = Map || {};
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
}).call(this);
