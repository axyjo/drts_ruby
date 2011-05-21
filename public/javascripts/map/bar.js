/* DO NOT MODIFY. This file was compiled Sat, 21 May 2011 19:54:20 GMT from
 * /home/akshay/Dropbox/Webdev/drts_ruby/app/scripts/map/bar.coffee
 */

(function() {
  var Map;
  Map = Map || {};
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
}).call(this);
