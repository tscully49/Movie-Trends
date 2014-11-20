var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var routes = require('./routes/index');
var users = require('./routes/users');
var http = require('http');
var pg = require('pg');

var app = express();

//Establish connection with database...
//var conString = "postgres://username:password@localhost/database";
//var conString = "postgres://cs3380f14grp12:bpVhIe1A@babbage.cs.missouri.edu:5432";
var conString = "postgres://postgres:genius00@localhost:3000";


pg.connect(conString, function(err, client, done) {
  if(err) {
    return console.error('error fetching client from pool', err);
  }
  if(client) {
    return console.log('Database connection established');
  }
  client.query("SELECT name FROM actor WHERE (name='Jackie %')", function(err, result) {
    //call `done()` to release the client back to the pool
    done();

    if(err) {
      return console.error('error running query', err);
    }
    console.log(result.rows[0].number);
    //output: 1
  });
});

// view engine setup 
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// We don't have a favicon image, so don't worry about this ---------------------------------------
// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico')); 
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/users', users);

app.get('/movies', function(req, res){res.render('movies.ejs');});
app.get('/error_page', function(req, res){res.render('error_page.ejs');});
app.get('/actors', function(req, res){res.render('actors.ejs')});
app.get('/box_office', function(req, res){res.render('boxOffice.ejs')});

// catch 404 and forward to error handler ----------------------------------------------------------
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers ----------------------------------------------------------------------------------

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;