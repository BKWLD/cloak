###
Configure the sitemap to be generated from the routes config
###
{ isGenerating } = require '../utils'
module.exports = ({ cms, pageTypes }) ->
	return unless isGenerating

	# Add the module
	modules: [ '@nuxtjs/sitemap' ]

		# Sitemap rules
	sitemap:

		# Get the hostname from Netlify
		hostname: process.env.URL

		# Remove routes that have robots disabled. This is necesary because sitemap
		# module is only passing the final URL rather than full object.
		routes: ->
			return [] unless pageTypes?.length
			getPages = switch cms
				when 'craft' then require '../../build/get-craft-pages'
				when 'contentful' then require '../../build/get-contentful-pages'
			(await getPages pageTypes).filter (route) -> switch

				# Allow simple string routes
				when typeof route == 'string' then true

				# Don't include routes with noindex
				when route.robots?.includes 'noindex' then false

				# Else, require a route property on the route object
				else !!route.route

		# Exclude all static routes, assuming everything is driven from routes
		exclude: ['**']
