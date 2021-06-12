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

# Execute a single entry
export getEntry = (payload) ->
	data = await execute payload
	return Object.values(data)[0]
