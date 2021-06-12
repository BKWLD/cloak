###
A webpack config that can converts GraphQL into importable JS
###

# Deps
path = require 'path'
glob = require 'glob'

# Paths
nuxtQueries = path.resolve process.cwd(), 'queries'

# Webpack config
module.exports =

	# Only rendering for production
	mode: 'production'

	# Blindly build all gql files from the queries directory.
	# https://stackoverflow.com/a/45827671/59160
	entry: glob.sync("#{nuxtQueries}/*.gql").reduce (entry, file) ->
		entry[path.parse(file).name] = file
		return entry
	, {}

	# Where to write files
	output:
		path: path.resolve nuxtQueries, 'compiled'
		filename: '[name].js'
		libraryTarget: 'commonjs2' # Necessary to get import-able

	# Add graphql loader
	module: rules: [
		test: /\.gql?$/
		loader: 'webpack-graphql-loader'
	]
