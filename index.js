'use strict'

let http =     require('http')
let url =      require('url')
let _static =  require('node-static')
let shutdown = require('power-off')
let sleep =    require('sleep-mode')



let fileServer = new _static.Server('.')
let server = http.createServer()

server.on('request', function (req, res) {
	let route = url.parse(req.url).pathname

	// index.html
	if (req.method === 'GET' && route === '/')
		return fileServer.serve(req, res)

	if (req.method !== 'POST') {
		res.statusCode = 400
		res.end('Only POST requests.')
	}



	if (route === '/power-off') return shutdown(function (err) {
		res.statusCode = err ? 500 : 200
		res.end(err ? err.toString() : 'Will power off now.')
	})

	if (route === '/sleep') return sleep(function (err) {
		res.statusCode = err ? 500 : 200
		res.end(err ? err.toString() : 'Will sleep now.')
	})



	res.statusCode = 400
	res.end('Invalid route.')
})

module.exports = server
