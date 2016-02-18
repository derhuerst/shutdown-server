'use strict'

sinon =  require 'sinon'
got =    require 'got'

requireMock = sinon.stub()
mock = (k, v) -> requireMock.withArgs(k).returns v

shutdownMock = sleepMock = null
mock 'http',           require 'http'
mock 'url',            require 'url'
mock 'node-static',    Server: -> serve: (req, res) -> res.end 'stubbed file'
mock 'power-off',      shutdownMock = sinon.stub()
mock 'sleep-mode',     sleepMock = sinon.stub()

moduleMock = exports: {}

server = require('nodeunit').utils.sandbox './index.js',
	require: requireMock
	module: moduleMock



module.exports =

	setUp: (cb) -> moduleMock.exports.listen 10000, cb
	tearDown: (cb) -> moduleMock.exports.close cb

	'GET /': (test) ->
		test.expect 1
		got 'http://localhost:10000/'
		.then (res) ->
			test.strictEqual res.body, 'stubbed file'
			test.done()

	'POST /power-off (success)': (test) ->
		test.expect 1
		shutdownMock.callsArgWith 0, null
		got.post 'http://localhost:10000/power-off'
		.then (res) ->
			test.strictEqual res.statusCode, 200
			test.done()

	'POST /power-off (failure)': (test) ->
		test.expect 2
		shutdownMock.callsArgWith 0, new Error 'foo'
		got.post 'http://localhost:10000/power-off'
		.catch (err) ->
			test.ok err instanceof got.HTTPError
			test.strictEqual err.statusCode, 500
			test.done()

	'POST /sleep (success)': (test) ->
		test.expect 1
		sleepMock.callsArgWith 0, null
		got.post 'http://localhost:10000/sleep'
		.then (res) ->
			test.strictEqual res.statusCode, 200
			test.done()

	'POST /sleep (failure)': (test) ->
		test.expect 2
		sleepMock.callsArgWith 0, new Error 'foo'
		got.post 'http://localhost:10000/sleep'
		.catch (err) ->
			test.ok err instanceof got.HTTPError
			test.strictEqual err.statusCode, 500
			test.done()
