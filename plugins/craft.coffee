###
Inject $craft globally
###
import * as craft from '../services/craft.coffee'
export default ({ }, inject) ->
	inject 'craft', craft
