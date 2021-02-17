###
Make a boilerplate Nuxt config while accepting some options
###

# Deps
mergeConfig = require './merger'
defaults = require 'lodash/defaults'

# Concerns that make up the whole boilerplate config
concerns = [
	require './concerns/axios'
	require './concerns/coffeescript'
	require './concerns/craft'
	require './concerns/globals'
	require './concerns/meta'
	require './concerns/polyfill'
	require './concerns/pwa'
	require './concerns/robots'
	require './concerns/sentry'
	require './concerns/sitemap'
	require './concerns/ssg'
	require './concerns/styles'
	require './concerns/title'
]

# Export merging function
module.exports = (options) ->

	# Make default options
	options = defaults options,

		# The name of the site
		siteName: 'New Site'

		# Polyfill.io keys
		polyfills: [
			'default'
			'URL'
			'NodeList.prototype.forEach'
			'IntersectionObserver'
			'Element.prototype.remove'
			'Object.values'
		]

		# Craft _typenames for page routes
		pageTypenames: []

		# Sentry repo name, like "Group Name / Repo Name"
		repoName: null

	# Merge all the concerns together, excuting their callbacks with the passed
	# in options. Filter out empty concerns, like if there was an early return.
	settings = concerns
	.map (concern) -> concern options
	.filter (concern) -> !!concern
	mergeConfig.apply null, settings
