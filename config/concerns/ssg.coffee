###
Prepare to statically generate the site using routes from a Craft query
###
getCraftPages = require '../../build/get-craft-pages'
{ isGenerating } = require '../utils'
module.exports = ({ pageTypenames }) ->

	# Always show output
	build: quiet: false

	generate:

		# Support falling back to a resolvable file on Netlify if a route didn't
		# exist when build was run.  We only want this to run when _not_ using
		# generate so we return true 404s.
		fallback: if isGenerating then false else '404.html'

		# Restrict the number of simulateneous requests so we don't consume too
		# many server connections.
		concurrency: 50

		# Don't use Nuxt 2.13 Crawler since we're explicitly creating all the
		# routes we care about and don't want to generate dead links.
		crawler: false

		# Sub folders, set to false to remove the trailing slashes
		subFolders: false

		# Add dynamic routes
		routes: -> getCraftPages pageTypenames
