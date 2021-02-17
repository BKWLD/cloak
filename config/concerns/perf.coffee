###
Tweaks intended for perf
###
{ isDev } = require '../utils'
module.exports = ->

	# Extract CSS into seperate files when statically generating to reduce JS
	# cost of injecting styles and to make them more cacheable
	build: extractCSS: not isDev

	# Remove preloading JS and CSS to improve PageSpeed scores. This pains me to
	# do because it seems so reasonable to have enabled but this does move the
	# needle on scores.
	render: resourceHints: false

	# Make seperate lighter build for modern browsers
	modern: if isDev then false else 'client'


