<!-- Conditionally render landscape or portrait visual instances -->

<script lang='coffee'>
import ContentfulVisual, { getAssetObject, makeSrcset } from './craft-visual'
import { ucFirst } from '../services/helpers'
export default
	name: 'ResponsiveContentfulVisual'
	props: {
		# Merge craft-visual props
		...ContentfulVisual.props
		# Make explicit landscape and portrait props
		landscapeImage: Object|Array
		portraitImage: Object|Array
		landscapeVideo: Object|Array
		portraitVideo: Object|Array
	}
	data: ->
		mounted: false
		isLandscape: null
	mounted: ->
		@isLanscapeMediaQuery = window.matchMedia '(orientation: landscape)'
		@checkIsLandscape @isLanscapeMediaQuery
		@isLanscapeMediaQuery.addListener @checkIsLandscape
		@mounted = true
	destroyed: ->
		@isLanscapeMediaQuery?.removeListener @checkIsLandscape
	computed:
		# Visual configs
		landscape: -> @makeConfig @getAsset('image', 'landscape'),
			@getAsset('video', 'landscape')
		portrait: -> @makeConfig @getAsset('image', 'portrait'),
			@getAsset('video', 'portrait')
		# Do we have unique landscape and portrait configs?
		isResponsive: -> !!(@landscape and @portrait)
		# The config used when there is both landscape and portrait assets. The video
		# prop will only be set once the viewport can be measured.
		responsiveConfig: ->
			return unless @isResponsive
			{
				...@landscape
				props: {
					...@landscape.props
					video: @responsiveVideo
				}
				class: 'responsive-visual'
				style:
					'--landscape-aspect': @makeAspectStyle 'landscape'
					'--portrait-aspect': @makeAspectStyle 'portrait'
			}
		# If there are both landscape and portrait videos, wait till the page is
		# mounted to decide which to show.  This prevents issues with differences
		# between SSR and client. Otherwise, just use whichever we have.
		responsiveVideo: ->
			landscape = @landscape.props.video
			portrait = @portrait.props.video
			if landscape and portrait
				return unless @mounted
				if @isLandscape then landscape else portrait
			else landscape || portrait
		# Make responsive sources
		responsiveSources: ->
			return unless @isResponsive
			[
				{
					attrs:
						media: '(orientation: landscape)'
						srcset: makeSrcset @landscape.props.image
						sizes: @sizes
				}
				{
					attrs:
						media: '(orientation: portrait)'
						srcset: makeSrcset @portrait.props.image
						sizes: @sizes
				}
			]
	methods:
		# Store whether orientation is currently landscape
		checkIsLandscape: (e) -> @isLandscape = e.matches
		# Get the specified asset
		# mediaType: image|video
		# viewportType: portrait|landscape
		getAsset: (mediaType, viewportType) ->
			getAssetObject @[viewportType + ucFirst(mediaType)]
		# Make the aspect css style
		makeAspectStyle: (viewportType) ->
			return unless image = @[viewportType].props.image
			aspect = image.width / image.height
			return "#{1 / aspect * 100}%"
		# Make the config object for the create function by keeping all data and
		# props except for replacing landscape and portrait with the asset itself
		makeConfig: (image, video) ->
			return unless image or video
			on: loaded: => @$emit 'loaded'
			props: {
				...@$props
				image
				video
				landscapeImage: undefined
				portraitImage: undefined
				landscapeVideo: undefined
				portraitVideo: undefined
			}

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

<!-- ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– -->

<style lang='stylus' scoped>
// Add responsive aspect ratio
.responsive-visual >>> .vv-aspect-shim
	@media(orientation landscape)
		padding-top var(--landscape-aspect) !important
	@media(orientation portrait)
		padding-top var(--portrait-aspect) !important
</style>
