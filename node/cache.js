var sys = require('sys');
var fs = require('fs');
var db = require('mysql');

var env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'));
var database = 'game_production';
var table = 'performance_metrics';

var cache = {}
var hit_count = 0
var miss_count = 0
function now() {
  return (new Date).getTime();
}

exports.put = function(key, value, ttl) {
  var expire = now() + ttl;
  cache[key] = {value: value, expire: expire}
  miss_count++;
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
      hit_count++;
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

setInterval(function() {
  var tot = hit_count + miss_count;
  if(tot == 0) {
    tot = 1
  }

  var client = db.createClient({
    host: env["DOTCLOUD_DB_MYSQL_HOST"],
    port: parseInt(env["DOTCLOUD_DB_MYSQL_PORT"]),
    user: env["DOTCLOUD_DB_MYSQL_LOGIN"],
    password: env["DOTCLOUD_DB_MYSQL_PASSWORD"],
    database: database
  });

  var h = hit_rate/tot*100;
  var m = miss_rate/tot*100;

  client.query('INSERT INTO ' + table + ' SET timestamp = NOW(), metric = ? ' +
    'description = ?, value = ?', ['tile_cache_hit_rate', 'in percent', h]);
  client.query('INSERT INTO ' + table + ' SET timestamp = NOW(), metric = ? ' +
    'description = ?, value = ?', ['tile_cache_miss_rate', 'in percent', m]);

  hit_count = 0;
  miss_count = 0;
}, 5*60*1000);
