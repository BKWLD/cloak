###
Helper to merge Nuxt configs smartly, like how Vue configs work
###

# Deps
flat = require 'flat'
unflatten = flat.unflatten
uniq = require 'lodash/uniq'
uniqBy = require 'lodash/uniqBy'

# Keys to arrays that should concatted and what property to dedupe by
concatableArrays =
	none: ['modules', 'buildModules', 'head.meta']
	hid: ['head.script']

# Do the merging
module.exports = (...args) ->

	# Merge the object
	args.reduce (config, settings) ->

		# Flatten the object for easier key inspection. Safe means don't apply
		# to arrays (which makes it easier for me to merge).
		config = flat config, safe: true
		settings = flat settings, safe: true

		# Combine array contents
		for key, val of settings
			for dedupeKey, concatableArray of concatableArrays
				continue unless key in concatableArray

				# Combine the arrays and remove from settings because it's been
				# processed
				config[key] = [...(config[key] || []), ...settings[key]]
				delete settings[key]

				# Dedupe by the appropriate property
				config[key] = if dedupeKey == 'none'
				then uniq config[key]
				else uniqBy config[key], 'hid'

		# Combine the final object
		return unflatten {...config, ...settings}
	, {}
