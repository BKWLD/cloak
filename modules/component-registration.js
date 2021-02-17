/**
 * Autoload anything in Cloak's components directory
 */
import { join } from 'path'
export default function () {
	this.nuxt.hook('components:dirs', dirs => {
		dirs.push({
			path: join(__dirname, '../components'),

			// Make these root level components
			pathPrefix: false,
		})
	})
}
