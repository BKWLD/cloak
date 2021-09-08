###
This mixin should be added to all pages/towers.  It adds functionality for
supporting Craft's preview mode as well as generating meta values automatically.
###
if process.env.CMS == 'craft'
then craftPreview = require('./craft-preview').default
import headTags from './head-tags'
export default
	mixins: [
		craftPreview
		headTags
	].filter (val) -> !!val
