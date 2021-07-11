###
Add Bukwild credits module when not dev-ing
###
{ isDev } = require '../utils'
module.exports = ->
	return if isDev
	modules: [
		'@bkwld/credits/nuxt/module'
	]
