var http = require('http'),
    faye = require('./faye');

var bayeux = new faye.NodeAdapter({
    mount:    '/',
    timeout:  45
});

var server = http.createServer();

bayeux.attach(server);
server.listen(8080);
