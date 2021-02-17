###
Add commonly used components and helpers
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
		join __dirname, '../../modules/components'
	]
