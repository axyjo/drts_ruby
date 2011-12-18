var sys = require('sys');
var fs = require('fs');
var db = require('mysql');

var env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'));
var database = 'game_production';
var table = 'performance_metrics';

var cache = {}
var tile_cache_hits = 0
var tile_cache_misses = 0
function now() {
  return (new Date).getTime();
}

exports.put = function(key, value, ttl) {
  var expire = now() + ttl;
  cache[key] = {value: value, expire: expire}
  tile_cache_misses++;
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
      tile_cache_hits++;
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

var update_cache_stats = function() {
  var tot = tile_cache_hits + tile_cache_misses;
  if(tot == 0) {
    tot = 1;
  }

  var client = db.createClient({
    host: env["DOTCLOUD_DB_MYSQL_HOST"],
    port: parseInt(env["DOTCLOUD_DB_MYSQL_PORT"]),
    user: env["DOTCLOUD_DB_MYSQL_LOGIN"],
    password: env["DOTCLOUD_DB_MYSQL_PASSWORD"],
    database: database
  });

  var h = tile_cache_hits/tot*100;
  var m = tile_cache_misses/tot*100;

  client.query('INSERT INTO ' + table + ' SET timestamp = NOW(), metric = ?,' +
    'description = ?, value = ?', ['tile_cache_hit_rate', 'in percent', h]);
  client.query('INSERT INTO ' + table + ' SET timestamp = NOW(), metric = ?,' +
    'description = ?, value = ?', ['tile_cache_miss_rate', 'in percent', m]);

  tile_cache_hits = 0;
  tile_cache_misses = 0;
}

setInterval(update_cache_stats, 10*60*1000);
