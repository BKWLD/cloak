###
Make a boilerplate Nuxt config while accepting some options
###

# Deps
mergeConfig = require './merger'
defaults = require 'lodash/defaults'

# Concerns that make up the whole boilerplate config
axios = require './concerns/axios.coffee'
coffeescript = require './concerns/coffeescript.coffee'
craft = require './concerns/craft.coffee'
globals = require './concerns/globals.coffee'
meta = require './concerns/meta.coffee'
polyfill = require './concerns/polyfill.coffee'
pwa = require './concerns/pwa.coffee'
ssg = require './concerns/ssg.coffee'
styles = require './concerns/styles'
title = require './concerns/title.coffee'

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

	# Merge all the concerns together
	mergeConfig.apply null, [
		axios options
		coffeescript options
		craft options
		globals options
		meta options
		polyfill options
		pwa options
		ssg options
		styles options
		title options
	]
