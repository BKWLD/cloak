###
Add commonly used components and helpers
###
{ join } = require 'path'
module.exports = ->

	# Auto discover components
	components: [
		'~/components'
		{ path: '~/components/global' }
	]

	# Add common, global components
	plugins: [
		{ src: join __dirname, '../../plugins/helpers' }
		{ src: join __dirname, '../../plugins/smart-link' }
		{ src: join __dirname, '../../plugins/vue-visual' }
		# { src: join __dirname, '../../plugins/wysiwyg' }
	]

	# Add modules that inject plugins
	modules: [
		'nuxt-page-transition-and-anchor-handler'
		'vue-routing-anchor-parser/nuxt/module'
	]

	# Auto-load cloak components
	buildModules: [
		join __dirname, '../../modules/components'
	]

	# Anchor parser rules
	anchorParser:
		addBlankToExternal: true
		internalUrls: [
			/^https?:\/\/localhost:\d+/
			/^https?:\/\/([\w\-]+\.)?netlify\.app/
		]
