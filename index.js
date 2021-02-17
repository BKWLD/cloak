// Auto-transpile CSS deps
require('coffeescript/register')

// Export public API
module.exports = {
	...require('./config/helpers.coffee'),
	mergeConfig: require('./config/merger.coffee'),
	makeBoilerplate: require('./config/boilerplate.coffee')
}
