###
Inject global helpers
###
{ join } = require 'path'
module.exports = ->

	# Expose useful ENV vars
	env:
		APP_ENV: process.env.APP_ENV || process.env.SENTRY_ENVIRONMENT || 'dev'

	# Load the helpers plugin that does the injection
	plugins: [
		{ src: join __dirname, '../../plugins/helpers' }
	]
