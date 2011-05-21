/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 13:45:44 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/map.bar.coffee
 */

(function() {
  Game.map.bar = Game.map.bar || {};
  Game.map.bar.init = function() {};
  Game.map.bar.populate = function(position) {
    if (position.x > 0 && position.y > 0 && position.x <= Game.map.mapSize && position.y <= Game.map.mapSize) {
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
  Game.map.bar.position = function(e) {
    var displacementX, displacementY, offset, position, x_val, y_val;
    displacementX = $("#map_bar").width();
    displacementY = 0;
    offset = $("#map_viewport").offset();
    offset.left -= displacementX;
    offset.top -= displacementY;
    x_val = e.pageX - displacementX - offset.left;
    y_val = e.pageY - displacementY - offset.top;
    x_val = Math.ceil(x_val / Game.map.coordinateLength());
    y_val = Math.ceil(y_val / Game.map.coordinateLength());
    position = {
      x: x_val,
      y: y_val
    };
    $("#map_position").html(position.x + ", " + position.y);
    return position;
  };
}).call(this);
