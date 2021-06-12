/**
 * Inject the Contentful plugin globally.  The way this is imported is a little
 * odd as a result of the plugin being added by the use-craft-in-store module.
 */
import * as contentful from '@bkwld/cloak/services/contentful.coffee'
export default ({ }, inject) => inject('contentful', contentful)
