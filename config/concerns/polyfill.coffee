###
Default polyfills
###
module.exports = ({ polyfills }) ->

	# Use Polyfill.io for most polyfills
	head: script: [
		do ->
			src = 'https://polyfill.io/v3/polyfill.min.js?features=' +
				polyfills.join '%2C'
			{ hid: 'polyfill', src, body: true }
	]

	# Add nuxt-polyfill for polyfill's not provided by polyfill.io
	modules: [
		'nuxt-polyfill'
	]

	# Setup conditionally polyfill-ing via nuxt-polyfill
	polyfill: features: [

		# Object fit is used by Vue Visual and this is the best polyfill I could
		# find that supported video and images well.
		{
			require: 'objectFitPolyfill'
			detect: -> document.documentElement.style.objectFit?
		}
	]
