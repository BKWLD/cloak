###
Setup component auto loading
###
{ join } = require 'path'
module.exports = ({ imgixUrl }) ->

	# Don't require "global" prefix on global components
	components: [
		'~/components'
		{ path: '~/components/globals' }
	]

	# Auto-load cloak components
	buildModules: [
		join __dirname, '../../modules/component-registration'
	]

	# Share imgixUrl with `craft-visual` to switch to using imgix to generate
	# image transform URLs
	env: IMGIX_URL: imgixUrl
