###
Fire GTM events on lifecycle events. The should be to trigger any pageview
type code
###
export default

	# Fire Page Mounted event
	mounted: ->
		window.dataLayer = [] unless window.dataLayer
		window.dataLayer.push 'Page Mounted'
