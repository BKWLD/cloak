###
Automatically set the title
###
module.exports = ({ siteName }) ->

	# Set to env so it's accessible in titleTemplate.  It needs to be done
	# both ways for server and client.
	process.env.SITE_NAME = siteName
	env: SITE_NAME: siteName

	# Return the titleTeimplate
	head: titleTemplate: (title) ->
		if title and title != process.env.SITE_NAME
		then "#{title} | #{process.env.SITE_NAME}"
		else process.env.SITE_NAME
