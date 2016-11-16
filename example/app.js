var express = require('express')
var querystring = require('querystring')
var mustacheExpress = require('mustache-express');
var request = require('request')
var argv = require('yargs').argv

if (argv.github_client_id === null || argv.github_client_id === true) {
  console.log('must provide command line arg --github_client_id=<insert GitHub client id>')
  return
}

if (argv.github_client_secret === null || argv.github_client_secret === true) {
  console.log('must provide command line arg --github_client_secret=<insert GitHub client secret>')
  return
}

var app = express()
app.engine('html', mustacheExpress())
app.set('view engine', 'mustache')

app.use(express.static('public'))

app.get('/', function (req, res) {
  res.render('index.html', {
    github_client_id: argv.github_client_id,
    github_access_token: null
  })
})

app.get('/github_oauth_redirect', function (req, res) {
  request({
    method: 'POST',
    url: 'https://github.com/login/oauth/access_token',
    qs: {
      client_id: argv.github_client_id,
      client_secret: argv.github_client_secret,
      code: req.query.code
    }
  }, function(err, response, body) {
    res.render('index.html', {
      github_client_id: argv.github_client_id,
      github_access_token: querystring.parse(body).access_token
    })
  })
})

app.listen(3000, function () {
    console.log('App listening on port 3000')
    console.log('http://localhost:3000/')
})
