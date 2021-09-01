###
Helpers that get injected into the Vue instance or can be imported directly
###

# Deps
import Vue from 'vue'

# Wait a tick then execute callback
export defer = (cb) -> setTimeout cb, 0

# Wait a tick then execute callback
export wait = (ms, cb) -> setTimeout cb, ms

# Filter an array to just non-empties
export nonEmpty = (array) -> array.filter (val) -> !!val

# Pad a number with 0s
export padNum = (num, size = 2) -> String(Math.round(num)).padStart(size, '0')

# Nl2br function, https://stackoverflow.com/a/784547/59160
export nl2br = (str) -> str.replace /(?:\r\n|\r|\n)/g, '<br>'

# Add two decimal places
export twoDecimals = (val) ->
	locale = navigator?.language || 'en-US'
	val.toLocaleString locale,
		minimumFractionDigits: 2
		maximumFractionDigits: 2

# Export validator rules
export validators =
	email: (val) -> /\S+@\S+\.\S+/.test(val) || 'Not a valid email'
	required: (val) -> !!val.trim() || 'This field is required'

# Helper for makking meta tags
export metaTag = (key, val, keyAttribute = null) ->

	# Make the key attribute
	unless @keyAttribute
		keyAttribute = if key.match /^og:/ then 'property' else 'name'

	# Get image from Craft's array
	if key == 'og:image' and Array.isArray val
	then val = makeImgixUrl val[0]?.path, 1200

	# Strip HTML by default, so WYSIWYG values can be passed in
	# https://stackoverflow.com/a/5002161/59160
	val = val?.replace /<\/?[^>]+(>|$)/g, ''

	# Return object
	hid: key
	"#{keyAttribute}": key
	content: val

# Mount a component on the body, like a modal, and return the mounted component
# instance. The "component" argument should be a Vue component instance, like
# returned from importing a single file component.
export mountOnBody = (component, options = {}) -> new Promise (resolve) ->
	mount = ->

		# Retry if nuxt not ready
		unless window.$nuxt then return wait 50, mount

		# Set default options
		unless options.parent then options.parent = window.$nuxt.$root

		# Mount the compenent
		vm = new (Vue.extend component)(options)
		vm.$mount()
		document.body.appendChild vm.$el
		resolve vm

	# Try to mount
	mount()

# Add JS initted class to document for use by in-viewport transitions
export addInittedClass = ->
	defer -> document.documentElement.classList.add 'js-initted'

# Add mixins at the app level
# https://github.com/nuxt/nuxt.js/issues/1593#issuecomment-384554130
export extendApp = (app, mixin) ->
	app.mixins = [] unless app.mixins
	app.mixins.push mixin

# Format a URL for Imgix
export makeImgixUrl = (path, width) ->
	return unless imgixUrl = process.env.IMGIX_URL
	return unless path
	return "#{imgixUrl}/#{path}" unless width
	"#{imgixUrl}/#{path}?w=#{width}&fit=max&auto=format&auto=compress"

# Format a URL for Contentful
export makeContentfulImageUrl = (url, width, {
	height, format, quality, fit
} = {}) ->
	return url unless url && width

	# Create query params
	params = {}
	params.w = width
	params.h = height if height
	params.fm = format if format
	params.q = quality if quality
	params.fl = 'progressive' if format == 'jpg'
	params.fit = fit if fit

	# Make the URL
	"#{url}?#{new URLSearchParams(params)}"

# Capitalize the first letter of a word
# https://flaviocopes.com/how-to-uppercase-first-letter-javascript/
export ucFirst = (str) -> str.charAt(0).toUpperCase() + str.slice(1)
