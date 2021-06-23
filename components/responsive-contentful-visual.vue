<!-- Conditionally render landscape or portrait visual instances -->

<script lang='coffee'>
import responsiveVisualMixin from '../mixins/visual/responsive-visual'
import ContentfulVisual, { makeSrcset } from './contentful-visual'
import { ucFirst } from '../services/helpers'
export default
	name: 'ResponsiveContentfulVisual'

	mixins: [ responsiveVisualMixin ]

	methods:

		# Get the specified asset
		# mediaType: image|video
		# viewportType: portrait|landscape
		getAsset: (mediaType, viewportType) ->
			@[viewportType + ucFirst(mediaType)]

		# Passthru the logic that makes a srceset from the passed in prop
		makeSrcset: makeSrcset

	# Make the appropriate visual instance
	render: (create) ->

		# Create visual for the current viewport width
		if @landscape || @portrait
			unless @isResponsive
			then create ContentfulVisual, @landscape || @portrait, @$slots.default
			else create ContentfulVisual, {
				...@responsiveConfig
				scopedSlots: ['image-source']: =>
					@responsiveSources.map (data) -> create 'source', data
			}, @$slots.default

		# No assets were discovered, so explicitly clear the asset props
		else create ContentfulVisual, { props: {
			...@$props
			image: undefined
			video: undefined
		}}, @$slots.default

</script>
