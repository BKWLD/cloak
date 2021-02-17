###
Add commonly used components
###
path = require 'path'
module.exports = ->

	# Add common, global, components
	plugins: [
		{ src: path.join __dirname, '../../plugins/smart-link' }
		{ src: path.join __dirname, '../../plugins/vue-visual' }
		{ src: path.join __dirname, '../../plugins/wysiwyg' }
	]
