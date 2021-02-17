###
Add commonly used components and helpers
###
path = require 'path'
module.exports = ->

	# Auto discover components
	components: true

	# Add common, global components
	plugins: [
		{ src: path.join __dirname, '../../plugins/helpers' }
		{ src: path.join __dirname, '../../plugins/smart-link' }
		{ src: path.join __dirname, '../../plugins/vue-visual' }
		{ src: path.join __dirname, '../../plugins/wysiwyg' }
	]

	# Add modules that inject plugins
	modules: [
		'nuxt-page-transition-and-anchor-handler'
		'vue-routing-anchor-parser/nuxt/module'
	]

	# Anchor parser rules
	anchorParser:
		addBlankToExternal: true
		internalUrls: [
			/^https?:\/\/localhost:\d+/
			/^https?:\/\/([\w\-]+\.)?netlify\.app/
		]
