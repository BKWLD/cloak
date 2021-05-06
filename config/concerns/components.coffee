###
Setup component auto loading
###
{ join } = require 'path'
module.exports = ({ imgixUrl, srcsetWidths, placeholderColor }) ->

	# Don't require "global" prefix on global components
	components: [
		'~/components'
		{ path: '~/components/globals' }
	]

	# Auto-load cloak components
	buildModules: [
		join __dirname, '../../modules/component-registration'
	]

	# Share vars with `craft-visual` to switch to using imgix to generate
	# image transform URLs as well as override defaults
	env:
		IMGIX_URL: imgixUrl
		SRCSET_WIDTHS: srcsetWidths
		PLACEHOLDER_COLOR: placeholderColor
