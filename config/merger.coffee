###
Helper to merge Nuxt configs smartly, like how Vue configs work
###

# Deps
flat = require 'flat'
unflatten = flat.unflatten
uniq = require 'lodash/uniq'
uniqBy = require 'lodash/uniqBy'
forEach = require 'lodash/forEach'

# Keys to arrays that should concatted and what property to dedupe by
concatableArrays =
	none: [
		'modules'
		'buildModules'
		'head.meta'
		'generate.ignore'
		'anchorParser.internalUrls'
	]
	hid: ['head.script', 'head.link']
	src: ['plugins']

# Keys for methods that should be chained, like how Vue mixins for lifecycle
# hooks work
chainableMethods = [
	'build.extend'
]

# Do the merging
module.exports = (...args) ->

	# Merge the object
	args.reduce (config, settings) ->

		# Flatten the object for easier key inspection. Safe means don't apply
		# to arrays (which makes it easier for me to merge).
		config = flat config, safe: true
		settings = flat settings, safe: true

		# Loop through the uncoming settings. Using a forEach rather than a
		# coffeescipt loop so that closures within this have the `key` frozen.
		Object.keys(settings).forEach (key) ->

			# Combine array contents
			for dedupeKey, concatableArray of concatableArrays
				continue unless key in concatableArray

				# Combine the arrays and remove from settings because it's been
				# processed
				config[key] = [...(config[key] || []), ...settings[key]]
				delete settings[key]

				# Dedupe by the appropriate property
				config[key] = if dedupeKey == 'none'
				then uniq config[key]
				else uniqBy config[key], dedupeKey

			# Chain chainable methods that are already in the config. Snapshot
			# functions outside of closure to prevent infinite recursion issues.
			if config[key] and key in chainableMethods
				configFunc = config[key]
				settingsFunc = settings[key]
				delete settings[key]
				config[key] = (...args) ->
					configFunc.apply null, args
					settingsFunc.apply null, args

		# Combine the final object
		return unflatten {...config, ...settings}
	, {}
