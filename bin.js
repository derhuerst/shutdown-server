#!/usr/bin/env node
'use strict'

const yargs =     require('yargs')
const sudoBlock = require('sudo-block')
const startup =   require('user-startup')
const path =      require('path')

const server =    require('./index')
const port =      require('./package.json').port || 5709



const argv = yargs
.usage('$0 <serve|start|stop>')
.help()

.command('serve', 'Start server in foreground.', function () {
	server.listen(port, function () {
		process.stdout.write(`Listening on port ${port}.\n`)
	})
})

.command('start', 'Start in background & put it to autostart.', function () {
	sudoBlock()
	startup.create('shutdown-server', process.execPath, [__filename, 'serve'], path.join(__dirname, 'log.txt'))
	process.stdout.write(`Autostart entry created.\n`)
})

.command('stop', 'Remove server from autostart.', function () {
	sudoBlock()
	startup.remove('shutdown-server')
	process.stdout.write(`Autostart entry removed.\n`)
})

.argv
