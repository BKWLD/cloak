###
Make a boilerplate Nuxt config while accepting some options
###

# Deps
mergeConfig = require './merger'
defaults = require 'lodash/defaults'

# Concerns that make up the whole boilerplate config
components = require './concerns/components.coffee'
meta = require './concerns/meta.coffee'
polyfill = require './concerns/polyfill.coffee'
pwa = require './concerns/pwa.coffee'
styles = require './concerns/styles'
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
		components options
		meta options
		polyfill options
		pwa options
		styles options
		title options
	]
