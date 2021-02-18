/**
 * Inject the Craft plugin globally.  The way this is imported is a little odd
 * as a result of the plugin being added by the use-craft-in-store module.
 */
import * as craft from '@bkwld/cloak/services/craft.coffee'
export default ({ }, inject) => inject('craft', craft)
