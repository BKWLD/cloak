###
Add various helpers related to routing
###
{ join } = require 'path'
module.exports = ->

	# Add common, global components
	plugins: [
		{ src: join __dirname, '../../plugins/smart-link' }
	]

	# Add packages responsible for improving page transition handling
	modules: [
		'nuxt-page-transition-and-anchor-handler'
		'vue-routing-anchor-parser/nuxt/module'
	]

	# Add a default route to towers
	router: extendRoutes: (routes, resolve) ->

		# Make the tower slug optional, so the root route will match
		routes.find (route) -> route.name == 'tower'
		.path = '/:tower*'

		# Return new routes array
		return routes

	# Anchor parser rules
	anchorParser:
		addBlankToExternal: true
		internalUrls: [
			/^https?:\/\/localhost:\d+/
			/^https?:\/\/([\w\-]+\.)?netlify\.app/
		]
