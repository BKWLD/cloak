###
A webpack config that can converts GraphQL into importable JS
###

# Deps
{ join } = require 'path'

# Paths
nuxtQueries = join process.cwd(), 'queries'

# Webpack config
module.exports =

	# Only rendering for production
	mode: 'production'

	# GraphQL files that will be built
	entry:
		'craft-pages': join nuxtQueries, 'craft-pages.gql'

	# Where to write files
	output:
		path: join nuxtQueries, 'compiled'
		filename: '[name].js'
		libraryTarget: 'commonjs2' # Necessary to get import-able

	# Add graphql loader
	module:
		rules: [
			test: /\.gql?$/
			use: [
				loader: 'webpack-graphql-loader'
			]
		]
