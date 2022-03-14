###
Configuration related to populating meta tags
###
module.exports = ->

	# This is used by head-tags
	env: URL: process.env.URL

	# Boilerplate meta tags
	head: meta: [
		{ 'http-equiv': 'X-UA-Compatible', content: 'IE=edge' }
		{ name: 'msapplication-tap-highlight', content:'no' }
	]
