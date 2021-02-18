###
Support fetching more data during Craft's preview mode
###
import debounce from 'lodash/debounce'
export default

	mounted: ->

		# Listen for content changes from Craft's preview mode
		window.addEventListener 'message', @onPostMessage

		# Immediately refresh if mounting into a preview request on SSG.
		if process.static && @isCraftPreviewRequest then @refreshData()

	# Cleanup listeners
	destroyed: -> window.removeEventListener 'message', @onPostMessage

	computed:

		# Check for the query string that means that this was requested inside
		# of the Craft preview iframe
		isCraftPreviewRequest: ->
			!!(@$route.query['x-craft-live-preview'] ||
			@$route.query['x-craft-preview'])

	methods:

		# Handle postMessages, looking for preview content updates
		onPostMessage: ({ origin, data }) ->
			return unless origin == (new URL process.env.CMS_ENDPOINT).origin
			@refreshData() if data == 'preview:change'

		# Refetch the page content then replace the page data.
		refreshData: debounce ->
			asyncData = @$route.matched?[0]?.components.default.options.asyncData
			return unless asyncData
			@$nuxt.$loading.start()
			data = await asyncData @$nuxt.context
			@[key] = val for key, val of data
			@$nuxt.$loading.finish()
		, 50
