###
Configure the sitemap to be generated from the routes config
###
{ join } = require 'path'
{ isGenerating } = require '../utils'
module.exports = ({ cms, pageTypes }) ->
	return unless isGenerating

	# Before adding the sitemap, add a custom module that filters the routes
	# from generate.routes by robots rules.
	modules: [
		join __dirname, '../../modules/filter-sitemap-routes'
		'@nuxtjs/sitemap'
	]

	# Sitemap rules
	sitemap:

		# Get the hostname from Netlify
		hostname: process.env.URL

		# Exclude all static routes, assuming everything is driven from routes
		exclude: ['**']
