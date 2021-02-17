###
Auto robots configuration
###
module.exports = ->

	# Add the module
	modules: [ '@nuxtjs/robots' ]

	# Disallow robots on non-prod
	robots: do ->

		# Allow all
		if 'prod' == process.env.APP_ENV and
		!process.env.URL?.includes 'netlify'
			Sitemap: "#{process.env.URL}/sitemap.xml"
			UserAgent: '*'
			Allow: '/'

		# Deny all
		else
			UserAgent: '*'
			Disallow: '/'
