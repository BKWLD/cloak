###
Setup style conventions like global styles, definitions.styl loading, etc
###
path = require 'path'
{ isDev } = require('../helpers.coffee')
module.exports = ->

	# Global styles
	css: [
		'normalize.css'
		'~assets/app.styl'
	]

	# Append definitions.styl everywhere
	styleResources: stylus: './assets/styles/definitions.styl'
	buildModules: [
		'@nuxtjs/style-resources'
	]

	# PostCSS config
	build: postcss: plugins:

		# Disable CSS Nano's Calc transfrom, it beefs with my fluid() function
		cssnano: do ->
			if isDev then false
			else preset: ['default', calc: false ]

	# Focus-visible for accessibility
	plugins: [
		{ src: path.join __dirname, '../../plugins/focus-visible' }
	]
