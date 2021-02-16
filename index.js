// Auto-transpile CSS deps
require('coffeescript/register')

// Export public API
module.exports = {
	mergeConfig: require('./config/merger.coffee'),
	makeBoilerplate: require('./config/boilerplate.coffee')
}
