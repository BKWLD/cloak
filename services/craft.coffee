import axios from 'axios'
import pickBy from 'lodash/pickBy'

# Check if generating
generating = process.env.npm_lifecycle_event == 'generate'

# Error object with custom handling
class CraftError extends Error
	name: 'CraftError'
	constructor: (errors, payload) ->
		super errors.map((e) -> e.debugMessage || e.message).join ', '
		@errors = errors.map (e) -> JSON.stringify e
		@payload = payload

# Run the API query
export execute = (payload) ->

	# Remove empty arrays from variables, which Craft treats as an explicit
	# requirement.  Like having no tags, which is something I don't think we
	# care about.
	if payload.variables
		payload.variables = pickBy payload.variables, (val, key) ->
			return false if Array.isArray(val) and val.length == 0
			return true

	# Excute the query
	response = await axios
		url: process.env.CMS_ENDPOINT
		method: 'post'
		headers: 'Content-Type': 'application/json'

		# Should have query and maybe variables data
		data: payload

		# Craft Preview / Share token
		params: getCraftPreviewTokens()

	# Handle errors in response
	if response.data.errors
		throw new CraftError response.data.errors, payload

	# Return data
	return response.data.data

# Get Craft preview tokens from the location
getCraftPreviewTokens = ->
	return unless window?
	return unless query = (new URL window.location.href).searchParams
	token: query.get('token')
	'x-craft-preview': query.get('x-craft-preview')
	'x-craft-live-preview': query.get('x-craft-live-preview')

# Execute a list of entries
export getEntries = (payload) ->
	{ entries } = await execute payload
	return entries

# Execute a list of entries
export getPaginatedEntries = (payload) ->
	{ entries, next } = await execute payload
	return { entries, hasMore: !!next }

# Get a single object
export getEntry = (payload) ->
	{ entry } = await execute payload
	return entry
