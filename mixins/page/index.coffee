###
This mixin should be added to all pages/towers.  It adds functionality for
supporting Craft's preview mode as well as generating meta values automatically.
###
import craftPreview from './craft-preview'
import headTags from './head-tags'
import gtmEvents from './gtm-events'
export default
	mixins: [
		craftPreview
		headTags
		gtmEvents
	]
