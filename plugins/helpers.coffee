###
Global helper methods
###
import * as helpers from '../services/helpers.coffee'
export default ({ error }, inject) ->

	# Make 404 response
	inject 'notFound', -> error
		statusCode: 404
		message: 'Page not found'

	# Inject all Cloak helpers
	inject name, func for name, func of helpers
