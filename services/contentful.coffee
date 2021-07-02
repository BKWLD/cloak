###
Make Contentful GraphQL adapter
###
import axios from 'axios'

# Not importing this from ./helpers because the dependency was causing issues
# when services/contentful was imported from a Nuxt module
nonEmpty = (array) -> array.filter (val) -> !!val

# Make a Contentful client
client = axios.create
	baseURL: 'https://graphql.contentful.com/content/v1/spaces/' +
		process.env.CONTENTFUL_SPACE
	headers:
		'Content-Type': 'application/json'
		'Authorization': 'Bearer ' + process.env.CONTENTFUL_ACCESS_TOKEN

# Retry requests when met with Contentful API rate limits.
# https://www.contentful.com/developers/docs/references/graphql/#/introduction/api-rate-limits
# This is based on https://github.com/compwright/axios-retry-after
# I tried using https://github.com/softonic/axios-retry but it wasn't retrying
# by default and I noticed a number of PRs for adding support for 429s. This
# requires no dependencies and is easier to understand.
client.interceptors.response.use null, (error) ->

	# Check for header with amount do delay
	delay = error.response?.headers?['x-contentful-ratelimit-reset']
	throw error unless delay
	console.log "Delaying #{delay}s for Contentful API rate limit"

	# Wait the delay and re-execute. Not entirely sure why client(error.config)
	# works but it does.
	await new Promise (resolve) -> setTimeout resolve, delay * 1000
	return client(error.config)

# Run the API query
export execute = (payload) ->

	# Excute the query
	response = await client
		method: 'post'
		data: payload # Should have query and optionally variables

	# Return data
	return response.data.data

# Execute a list of entries
export getEntries = (payload) ->
	data = await execute payload
	return flattenEntries Object.values(data)[0]?.items

# Execute a single entry and, if the query was for a collection, get the first
# item in the collection. Otherwise, it's assumed the query was for a single
# entry, so just resturn that result.
export getEntry = (payload) ->
	data = await execute payload
	result = Object.values(data)[0]
	return flattenEntry result?.items?[0] || result

# Execute a query that gets multiple collections, and return the flattened
# collections.
export getCollections = (payload) ->
	data = await execute payload
	Object.keys(data).forEach (key) ->
		data[key] = flattenEntries data[key]?.items
	return data

# Remove empty items (like when using the non-preview GraphQL endpoint and
# there are draft entries in a reference field).
export flattenEntries = (items) ->
	return [] unless items
	nonEmpty(items).map flattenEntry

# Contentful nests each sub collection in an items property. This removes all
# of the items properties and adds sys.id as the id so:
# - tower.sys.id -> tower.id
# - tower.blocks.items[0].title -> tower.blocks[0].title
# - tower.blocks.items[0].sys.id -> tower.blocks[0].id
export flattenEntry = (entry) ->
	Object.keys(entry).reduce (obj, key) ->
		switch

			# Flatten some of the sys vars onto the obj itself
			when key == 'sys'
				obj.id = id if id = entry.sys.id
				obj.createdAt = createdAt if createdAt = entry.sys.firstPublishedAt
				obj.updatedAt = updatedAt if updatedAt = entry.sys.publishedAt

			# Flatten `items` and recurse through children
			when (items = entry[key]?.items) and Array.isArray items
			then obj[key] = flattenEntries items

			# Otherwise, passthrough the key/val
			else obj[key] = entry[key]

		# Return the entry obj
		return obj
	, {}
