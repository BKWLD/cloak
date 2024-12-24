###
PWA module configuration
###
module.exports = ({ siteName }) ->

	# Nuxt.js modules
	modules: [
		'@nuxtjs/pwa'
	]

	# Meta and manifest settings
	manifest:
		theme_color: 'white'

		# Some defaults
		name: siteName
		short_name: siteName
		ogSiteName: siteName
		twitterCard: 'summary_large_image'

		# Don't autogenerate these, rely on the head config and/or normal meta
		# fields
		description: ''
		ogTitle: ''
		ogDescription: ''
		ogImage: ''
		author: ''
		
	# Force PWA to reload icon on build
	pwa: icon: cacheDir: "node_modules/.cache/pwa/icon"
