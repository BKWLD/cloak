###
Add coffeescript support
###
module.exports = ->

	# Add coffeescript module
	buildModules: [
		'nuxt-coffeescript-module'
	]

	# Try to ignore nuxt.config.coffee when generating
	generate: ignore: [
		'nuxt.config.coffee'
	]
