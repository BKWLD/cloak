###
Add configuration required to interact with Craft headlessly
###
path = require 'path'
module.exports = ->

	# Pass through env vars
	env:
		CMS_ENDPOINT: process.env.CMS_ENDPOINT

	# Expect a tower/block configuration at the minimum
	router: extendRoutes: (routes, resolve) ->

		# Make the tower slug optional, so the root route will match
		routes.find (route) -> route.name == 'tower'
		.path = '/:tower*'

		# Return new routes array
		return routes

	# Use Axios to interact with Craft API
	modules: [
		'@nuxtjs/axios'
	]

	# Prevent axios from using localhost:3000 when SSGed
	axios:
		baseURL: process.env.URL
		progress: false # Don't trigger loader

	# Inject Craft helper
	plugins: [
		{ src: path.join __dirname, '../../plugins/craft' }
	]

	# Make gql files importable
	build: extend: (config, { isDev }) ->
		config.module.rules.push
			test: /\.gql?$/
			use: [
				loader: 'webpack-graphql-loader'
				options: minify: !isDev
			]
		return config

	# Expect to support CMS-able redirects
	buildModules: [
		# '~/build/redirects'
	]
