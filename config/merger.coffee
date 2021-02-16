###
Helper to merge Nuxt configs smartly, like how Vue configs work
###
flat = require 'flat'
unflatten = flat.unflatten
uniq = require 'lodash/uniq'
module.exports = (...args) ->

	# Merge the object
	args.reduce (config, settings) ->

		# Flatten the object for easier key inspection. Safe means don't apply
		# to arrays (which makes it easier for me to merge).
		config = flat config, safe: true
		settings = flat settings, safe: true

		# Combine thee array contents uniquely
		for key, val of settings
			if key in ['modules', 'buildModules']
				config[key] = uniq [...(config[key] || []), ...settings[key]]
				delete settings[key]

		# Combine the final object
		return unflatten {...config, ...settings}
	, {}
