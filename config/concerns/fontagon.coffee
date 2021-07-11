###
Add nuxt-fontagon
###
{ resolve } = require 'path'
kebabCase = require 'lodash/kebabCase'
module.exports = ->

	# Register the module
	buildModules: [
		'nuxt-fontagon'
	]

	# Configuration
	iconFont:

		# How to generate
		files: ['assets/fonts/fontagon/*.svg']
		dist: 'assets/fonts/fontagon/dist'
		fontName: 'fontagon'

		# Use stylus
		style: 'stylus'
		styleTemplate: stylus: resolve __dirname,
			'../../build/fontagon-template.hbs'

		# Generate CSS class name
		classOptions: classPrefix: 'icon'
		rename: (fullpath) ->
			name = fullpath
				.replace(/^.*[\\\/]/, '') # Get basename
				.replace(/\.svg$/, '') # Remove the ".svg"
			kebabCase name


