# Use Cloak to make boilerplate
{ mergeConfig, makeBoilerplate, isDev, isGenerating } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
	siteName: 'Project'
	repoName: 'Organiztion / Project'

# Nuxt config
module.exports = mergeConfig boilerplate,

	# Add production internal URL
	anchorParser: internalUrls: [
		# /^https?:\/\/(www\.)?domain\.com/
	]
