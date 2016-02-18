#!/usr/bin/env node
const server = require('./index')
const port = require('./package.json').port || 5709
server.listen(port, function () {
	console.log(`Listening on port ${port}.`)
})
