###
This mixin should be added to all pages/towers.  It adds functionality for
supporting Craft's preview mode as well as generating meta values automatically.
###
craftPreview = require './craft-preview' if process.env.CMS == 'craft'
import headTags from './head-tags'
export default
	mixins: [
		craftPreview
		headTags
	].filter (val) -> !!val
