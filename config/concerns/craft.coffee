###
Add configuration required to interact with Craft headlessly
###
path = require 'path'
module.exports = ->
	throw 'Missing CMS_ENDPOINT' unless process.env.CMS_ENDPOINT

	# The GrapgQL endpoint
	env: CMS_ENDPOINT: process.env.CMS_ENDPOINT

	# Expect a tower/block configuration at the minimum
	router: extendRoutes: (routes, resolve) ->

		# Make the tower slug optional, so the root route will match
		routes.find (route) -> route.name == 'tower'
		.path = '/:tower*'

		# Return new routes array
		return routes

	# Inject Craft helper
	plugins: [
		{ src: path.join __dirname, '../../plugins/craft' }
	]

	# Expect to support CMS-able redirects
	buildModules: [
		# '~/build/redirects'
	]
