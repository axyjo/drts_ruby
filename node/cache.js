var sys = require('sys');
var fs = require('fs');
var db = require('db-mysql');

var env = JSON.parse(fs.readFileSync('/home/dotcloud/environment.json', 'utf-8'));

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
  db.Database({
    hostname: env["DOTCLOUD_DB_MYSQL_HOST"],
    port: env["DOTCLOUD_DB_MYSQL_PORT"],
    user: env["DOTCLOUD_DB_MYSQL_LOGIN"],
    password: env["DOTCLOUD_DB_MYSQL_PASSWORD"],
    database: 'game_production'
  }).connect(function(err) {
    var h = hit_rate/tot*100;
    var m = miss_rate/tot*100;
    this.query().insert('performance_metrics',
      ['timestamp', 'metric', 'description', 'value'],
      [{value: 'NOW', escape: false}, 'tile_cache_hit_rate', 'in percent', h]
    ).insert('performance_metrics',
      ['timestamp', 'metric', 'description', 'value'],
      [{value: 'NOW', escape: false}, 'tile_cache_miss_rate', 'in percent', m]
    ).execute(function(err, result) {
      hit_count = 0;
      miss_count = 0;
    });
  });
}, 5*60*1000);
