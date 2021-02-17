// Auto-transpile CSS deps
require('coffeescript/register')

// Suport ES6 module syntax
require = require("esm")(module)

// Export public API
module.exports = {
	...require('./config/utils'),
	mergeConfig: require('./config/merger'),
	makeBoilerplate: require('./config/boilerplate')
}
