###
Make a boilerplate Nuxt config while accepting some options
###
mergeConfig = require './merger'
makePwaConfig = require './concerns/pwa.coffee'
module.exports = (options) ->
	return mergeConfig makePwaConfig()
