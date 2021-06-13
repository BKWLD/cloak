/**
 * Filter the noindex routes out of the generated routes before sitemap can
 * acts on them. This is necessary because the sitemap modules filter()
 * doesn't expose the robots property of the route.
 */
export default function () {
	const { nuxt } = this
	nuxt.options.sitemap.routes = async () => {
		return (await nuxt.options.generate.routes()).filter((route) => {

			// Allow simple string routes
			if (typeof route == 'string') return true

			//  Don't include routes with noindex
			if (route.robots && route.robots.includes('noindex')) return false

			// Else, require a route property on the route object
			return !!route.route
		})
	}
}
