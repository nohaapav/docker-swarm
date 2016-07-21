var http = require('http');

const PORT = 8080;

function handleRequest(request, response) {
    http.get('http://service:8080', function (res) {
        res.on('data', function (chunk) {
            response.end('Test service respond with given data: ' + chunk);
        });
    }).end();
}

var server = http.createServer(handleRequest);
server.listen(PORT, function () {
    console.log("Server listening on: http://localhost:%s", PORT);
});

