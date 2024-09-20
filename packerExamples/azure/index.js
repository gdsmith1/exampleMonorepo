var express = require('express')
var app = express()
var os = require('os');
app.get('/', function (req, res) {
  res.send('DevOps Bootcamp sample app running on host ' + os.hostname() + '!')
})
app.listen(3000, function () {
  console.log('Test app listening on port 3000!')
})