###
Setup component auto loading
###
{ join } = require 'path'
module.exports = ->

	# Don't require "global" prefix on global components
	components: [
		'~/components'
		{ path: '~/components/global' }
	]

	# Auto-load cloak components
	buildModules: [
		join __dirname, '../../modules/component-registration'
	]
