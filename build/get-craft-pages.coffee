###
Query for all Craft pages given an array of _typenames
###
path = require 'path'
memoize = require 'lodash/memoize'
flatten = require 'lodash/flatten'
getCraftPages = require path.join process.cwd(), '/queries/compiled/craft-pages'
{locales} = require path.join process.cwd(), '/data/locales'
{ getEntries } = require '../services/craft'
{ isGenerating } = require '../config/utils'

# Make the list of routes
module.exports = memoize (pageTypenames) ->
	return [] unless isGenerating and pageTypenames.length
	routes = []

	# Loop through type combinations and add to
	console.log('ℹ Fetching SSG data')
	for typename in pageTypenames
		results = await Promise.all(locales.map((locale) -> getEntriesForTypename(typename, locale.siteHandle)).flat())

		# Make the list of routes
		routes = [
			...routes,
			...flatten(results).map (entry) ->
				siteHandle = if entry.siteHandle == 'default' then '' else entry.siteHandle
				route = if entry.uri == '__home__' then "/" else "/#{entry.uri}"

				return
					# Craft used the `__home__` slug for the homepage
					route: if siteHandle then "/#{siteHandle}" + route else route

					# Look for robots data within a Supertable instance called `seo` or
					# in a robots field directly on the entry
					robots: entry.seo?[0]?.robots || entry.robots || []

					# Wrap in array, so same as asyncData's query
					payload: [ entry ]
		]

	# Return final routes
	console.log('✔ Fetched SSG data')
	return routes

# Make a query given a pageTypeName
getEntriesForTypename = (typename, site) ->
	[ section, type ] = typename.split '_'
	getEntries
		query: getCraftPages
		variables: { section, type, site }
