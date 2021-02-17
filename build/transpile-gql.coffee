###
A webpack config that can converts GraphQL into importable JS
###

# Deps
{ resolve } = require 'path'

# Paths
nuxtQueries = resolve process.cwd(), 'queries'

# Webpack config
module.exports =

	# Only rendering for production
	mode: 'production'

	# GraphQL files that will be built
	entry:
		'craft-pages': resolve nuxtQueries, 'craft-pages.gql'

	# Where to write files
	output:
		path: resolve nuxtQueries, 'compiled'
		filename: '[name].js'
		libraryTarget: 'commonjs2' # Necessary to get import-able

	# Add graphql loader
	module: rules: [
		test: /\.gql?$/
		loader: 'webpack-graphql-loader'
	]
