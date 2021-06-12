/**
 * Add cms plugin before nuxt-spa-store-init so that it can be referenced during
 * nuxtServerInit()
 */
const { join } = require('path')
module.exports = function ({ cms }) {

	// This results in it's plugin being added last :shrug:
	this.requireModule('nuxt-spa-store-init')

	// This loads the service for the selected cms
	this.addPlugin({
		src: join(__dirname, `../plugins/${cms}.js`)
	});
}
