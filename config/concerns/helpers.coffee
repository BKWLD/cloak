###
Inject global helpers
###
{ join } = require 'path'
module.exports = ->
	plugins: [
		{ src: join __dirname, '../../plugins/helpers' }
	]
