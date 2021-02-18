###
Configure the sitemap to be generated from the routes config
###
getCraftPages = require '../../build/get-craft-pages'
{ isGenerating } = require '../utils'
module.exports = ({ pageTypenames }) ->
	return unless isGenerating

	# Add the module
	modules: [ '@nuxtjs/sitemap' ]

		# Sitemap rules
	sitemap:

		# Get the hostname from Netlify
		hostname: process.env.URL

		# Remove routes that have robots disabled
		routes: -> (await getCraftPages pageTypenames).filter (route) ->

			# Allow simple string routes
			return route if typeof route == 'string'

			# Don't include routes with noindex
			return if route.robots.includes 'noindex'

			# If an object with a route property, return it
			return route.route

		# Exclude all static routes, assuming everything is driven from routes
		exclude: ['**']
