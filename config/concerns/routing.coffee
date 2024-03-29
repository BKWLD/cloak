###
Add various helpers related to routing
###
path = require 'path'
{ existsSync } = require 'fs'
module.exports = ->

	# Add packages responsible for improving page transition handling
	modules: [
		'vue-routing-anchor-parser/nuxt/module'
	]

	# Add a default route to towers
	router: extendRoutes: (routes, resolve) ->

		# Make the tower slug optional, so the root route will match. This also
		# adds support for slashes without Tower URIs.
		if existsSync path.join process.cwd(), 'pages/_tower.vue'
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
