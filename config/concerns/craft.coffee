###
Add configuration required to interact with Craft headlessly
###
path = require 'path'
module.exports = ->
	throw 'Missing CMS_ENDPOINT' unless process.env.CMS_ENDPOINT

	# The GrapgQL endpoint
	env: CMS_ENDPOINT: process.env.CMS_ENDPOINT

	# Inject Craft helper
	plugins: [
		{ src: path.join __dirname, '../../plugins/craft' }
	]
