var parse = require('csv-parse');
var pg = require('pg');
var fs = require('fs');
var http = require('http');

var i;
var filepath = "/BoxOfficeData/1979.csv";
//Make sure this connection string is updated!
var conString = "postgres://username:password@localhost/database";
for (i = 1980; i < 2015; ++i) {
	filepath.replace((i - 1).toString(), i.toString());
	fs.readFile(filepath, function (err, data) {
		if (err) throw err;
		var parser = parse(data, function(err, output) {
			var x;
			for (x in output) {
				var apicall = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=bv7gsaaa3f6mgumrq7djbdgf&q=title&page_limit=1"
				var title = x[1].replace(" ", "+");
				apicall.replace("title", title);
				http.get(apicall, function(res) {
					response = JSON.parse(res);
					pg.connect(conString, function(err, client, done) {
						if(err) {
							return console.error('error fetching client from pool', err);
						}
						//client.query needs work
						client.query('INSERT INTO movie VALUES (DEFAULT, $1, $2, $3, $4', [response.movies.title, response.movies.], function(err, result) {
							//call `done()` to release the client back to the pool
							done();

							if (err) {
								return console.error('error running query', err);
							} else {
								console.log('Inserted ' + title + );
							}
						});
					});
				});
			}
		});
	});
}