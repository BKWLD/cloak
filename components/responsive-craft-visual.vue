<!-- Conditionally render landscape or portrait visual instances -->

<script lang='coffee'>
import responsiveVisualMixin from '../mixins/visual/responsive-visual'
import CraftVisual, { getAssetObject, makeSrcset } from './craft-visual'
import { ucFirst } from '../services/helpers'
export default
	name: 'ResponsiveCraftVisual'

	mixins: [ responsiveVisualMixin ]

	props: {
		...responsiveVisualMixin.props

		# Add support for array props
		landscapeImage: Object | Array
		portraitImage: Object | Array
		landscapeVideo: Object | Array
		portraitVideo: Object | Array

		# Shorthands, for passing a supertable with landscape or portrait object
		image: Object | Array
		video: Object | Array
	}

	methods:

		# Get the specified asset
		# mediaType: image|video
		# viewportType: portrait|landscape
		getAsset: (mediaType, viewportType) ->

			# Get from supertable shorthand object
			if superTableAsset = getAssetObject @[mediaType]
			then getAssetObject superTableAsset[viewportType]

			# Get explicit value
			else getAssetObject @[viewportType + ucFirst(mediaType)]

		# Passthru the logic that makes a srceset from the passed in prop
		makeSrcset: makeSrcset

	# Make the appropriate visual instance
	render: (create) ->

		# Create visual for the current viewport width
		if @landscape || @portrait
			unless @isResponsive
			then create CraftVisual, @landscape || @portrait, @$slots.default
			else create CraftVisual, {
				...@responsiveConfig
				scopedSlots: ['image-source']: =>
					@responsiveSources.map (data) -> create 'source', data
			}, @$slots.default

		# No assets were discovered, so explicitly clear the asset props
		else create CraftVisual, { props: {
			...@$props
			image: undefined
			video: undefined
		}}, @$slots.default

</script>
