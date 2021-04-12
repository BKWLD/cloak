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

			// Load at a higher level so project components can override them. I
			// chose "2" thinking that an explicit component library loaded from the
			// project may use "1".
			level: 2,
		})
	})
}
