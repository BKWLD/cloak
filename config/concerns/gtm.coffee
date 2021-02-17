###
Expect to use GTM
###
module.exports = ->
	return unless process.env.GTM_ID

	# Load module
	modules: [ '@nuxtjs/gtm' ]

	# Configure GTM, expect to trigger pageview events manually
	gtm:
		id: process.env.GTM_ID
		pageTracking: false
