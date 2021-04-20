###
Config Sentry error logging
###
module.exports = () ->
	return unless process.env.SENTRY_DSN

	# Add module
	modules: [ '@nuxtjs/sentry' ]

	# Configure Sentry
	sentry:
		publishRelease: true
		attachCommits: false
		config:
			release: process.env.COMMIT_REF
			environment: process.env.SENTRY_ENVIRONMENT || process.env.APP_ENV
			extra: # Netlify env variables
				url: process.env.URL
				deploy_url: process.env.DEPLOY_URL
		webpackConfig: setCommits:
			auto: true
