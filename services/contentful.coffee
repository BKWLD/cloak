###
Make Contentful GraphQL adapter
###
import axios from 'axios'

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
	return Object.values(data)[0]?.items

# Execute a single entry and, if the query was for a collection, get the first
# item in the collection. Otherwise, it's assumed the query was for a single
# entry, so just resturn that result.
export getEntry = (payload) ->
	data = await execute payload
	result = Object.values(data)[0]
	return result?.items?[0] || result
