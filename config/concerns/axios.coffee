###
Setup axios globally and add support for graphql
###
module.exports = ->

	# Install via Nuxt module
	modules: [
		'@nuxtjs/axios'
	]

	# Prevent axios from using localhost:3000 when SSGed
	axios:
		baseURL: process.env.URL
		progress: false # Don't trigger loader

	# Make gql files importable
	build: extend: (config, { isDev }) ->
		config.module.rules.push
			test: /\.gql?$/
			use: [
				loader: 'webpack-graphql-loader'
				options: minify: !isDev
			]
		return # Don't implicitly return
