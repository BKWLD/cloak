###
Helper to merge Nuxt configs smartly, like how Vue configs work
###
flat = require 'flat'
unflatten = flat.unflatten
module.exports = (...args) ->

	# Merge the object
	args.reduce (config, settings) ->

		# Flatten the object for easier key inspection
		config = flat config
		settings = flat settings

		# Else, add the new settings onto the end, replacing an earlier ones
		config = {...config, ...settings}

		# Return the unflattened object
		return unflatten config
	, {}
