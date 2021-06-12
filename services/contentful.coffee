###
Make Contentful GraphQL adapter
###
import axios from 'axios'

# Run the API query
export execute = (payload) ->

	# Excute the query
	response = await axios
		url: 'https://graphql.contentful.com/content/v1/spaces/' +
			process.env.CONTENTFUL_SPACE
		method: 'post'
		headers:
			'Content-Type': 'application/json'
			'Authorization': 'Bearer ' + process.env.CONTENTFUL_ACCESS_TOKEN

		# Should have query and maybe variables data
		data: payload

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
