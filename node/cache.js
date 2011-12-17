var sys = require('sys');

var cache = {}
function now() {
  return (new Date).getTime();
}

exports.put = function(key, value, ttl) {
  var expire = now() + ttl;
  cache[key] = {value: value, expire: expire}

  if(!isNaN(expire)) {
    setTimeout(function() {
      exports.del(key);
    }, expire);
  }
}

exports.del = function(key) {
  delete cache[key];
}

exports.get = function(key) {
  var data = cache[key];
  if(typeof data != "undefined") {
    if(isNaN(data.expire) || data.expire >= now()) {
      return data.value;
    } else {
      exports.del(key);
    }
  }
  return null;
}

exports.getTTL = function(key) {
  var data = cache[key];
  if(typeof data != "undefined") {
    if(isNaN(data.expire) || data.expire >= now()) {
      return data.expire - now();
    } else {
      exports.del(key);
    }
  }
  return null;
}
