###
Make a boilerplate Nuxt config while accepting some options
###

# Deps
mergeConfig = require './merger'
defaults = require 'lodash/defaults'

# Concerns that make up the whole boilerplate config
meta = require './concerns/meta.coffee'
polyfill = require './concerns/polyfill.coffee'
pwa = require './concerns/pwa.coffee'
title = require './concerns/title.coffee'

# Export merging function
module.exports = (options) ->

	# Make default options
	options = defaults options,
		siteName: 'New Site'
		polyfills: [
			'default'
			'URL'
			'NodeList.prototype.forEach'
			'IntersectionObserver'
			'Element.prototype.remove'
			'Object.values'
		]

	# Merge all the concerns together
	mergeConfig.apply null, [
		meta options
		polyfill options
		pwa options
		title options
	]
