###
Global helper methods
###
export default ({ error }, inject) ->

	# Make 404 response
	inject 'notFound', -> error
		statusCode: 404
		message: 'Page not found'
