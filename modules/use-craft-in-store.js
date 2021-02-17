/**
 * Add Craft plugin before nuxt-spa-store-init. These plugins are added in
 * reverse order
 */
const { join } = require('path')
module.exports = function () {

	// Adds this last
	this.requireModule('nuxt-spa-store-init')

	// This sets up the craft service
	this.addPlugin({
		src: join(__dirname, '../plugins/craft.js')
	});
}
