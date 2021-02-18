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

	# This package doesn't ship transpiled, so this asks Nuxt to do it
	build: transpile: [
		'@bkwld/cloak'
	]
