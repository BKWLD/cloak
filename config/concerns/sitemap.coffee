###
Configure the sitemap to be generated from the routes config
###
{ isGenerating } = require('../utils')
module.exports = ->
	return unless isGenerating

	# Add the module
	modules: [ '@nuxtjs/sitemap' ]

		# Sitemap rules
	sitemap:

		# Get the hostname from Netlify
		hostname: process.env.URL

		# Remove routes that have robots disabled
		filter: ({ routes }) -> routes.filter (route) ->

			# Allow simple string routes
			return route if typeof route == 'string'

			# Don't include routes with noindex
			return if route.robots.includes 'noindex'

			# If an object with a route property, return it
			return route.route

		# Exclude all static routes, assuming everything is driven from routes
		exclude: ['**']