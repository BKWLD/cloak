###
Add configuration required to interact with Craft headlessly
###
{ join } = require 'path'
module.exports = ->
	throw 'Missing CMS_ENDPOINT' unless process.env.CMS_ENDPOINT

	# The GrapgQL endpoint
	env: CMS_ENDPOINT: process.env.CMS_ENDPOINT

	# Inject Craft helper via the use-craft-in-store module
	modules: [
		join __dirname, '../../modules/use-craft-in-store'
	]
