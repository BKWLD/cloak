/**
 * Immediately exit SSG when an error is encountered
 */
export default function() {
	this.nuxt.hook('generate:routeFailed', ({ route, errors }) => {
		errors.forEach(error => console.error(error))
		process.exit(1)
	})
}
