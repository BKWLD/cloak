###
Configure the sitemap to be generated from the routes config
###
{ isGenerating } = require '../utils'
module.exports = ({ cms, pageTypenames }) ->
	return unless isGenerating

	# Add the module
	modules: [ '@nuxtjs/sitemap' ]

		# Sitemap rules
	sitemap:

		# Get the hostname from Netlify
		hostname: process.env.URL

		# Remove routes that have robots disabled
		routes: ->
			return [] unless pageTypenames?.length
			getPages = switch cms
				when 'craft' then require '../../build/get-craft-pages'
				when 'contentful' then require '../../build/get-contentful-pages'
			(await getPages pageTypenames).filter (route) ->

				# Allow simple string routes
				return route if typeof route == 'string'

				# Don't include routes with noindex
				return if route.robots.includes 'noindex'

				# If an object with a route property, return it
				return route.route

		# Exclude all static routes, assuming everything is driven from routes
		exclude: ['**']
