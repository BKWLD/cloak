###
Make a boilerplate Nuxt config while accepting some options
###
mergeConfig = require './merger'

# Concerns that make up the whole boilerplate config
pwa = require './concerns/pwa.coffee'
title = require './concerns/title.coffee'

# Merge all the concerns together
module.exports = (options) -> mergeConfig.apply null, [
	pwa options
	title options
]
