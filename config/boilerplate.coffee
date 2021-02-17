###
Make a boilerplate Nuxt config while accepting some options
###

# Deps
mergeConfig = require './merger'
defaults = require 'lodash/defaults'

# Concerns that make up the whole boilerplate config
concerns = [
	require './concerns/axios.coffee'
	require './concerns/coffeescript.coffee'
	require './concerns/craft.coffee'
	require './concerns/globals.coffee'
	require './concerns/meta.coffee'
	require './concerns/polyfill.coffee'
	require './concerns/pwa.coffee'
	require './concerns/robots.coffee'
	require './concerns/ssg.coffee'
	require './concerns/styles'
	require './concerns/title.coffee'
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

	# Merge all the concerns together, excuting their callbacks with the passed
	# in options
	mergeConfig.apply null, concerns.map (concern) -> concern(options)
