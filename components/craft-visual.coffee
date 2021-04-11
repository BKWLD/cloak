# Load Vue Visual
import Visual from 'vue-visual'
import 'vue-visual/index.css'

# We may be using imgix
import { makeImgixUrl } from '../services/helpers'

# The srcset sizes that will be produced, whether by imgix or through Craft
# transforms
resizeWidths = [1920, 1440, 1024, 768, 425, 210]

# Default placeholder color
export defaultPlaceholderColor = '#f3f3f2'

# Make the list of base Visual props, manually merging all mixins
baseProps = Visual.mixins.reduce (props, mixin) ->
	{ ...props, ...mixin.props }
, { ...Visual.props }

# Map Craft image objects into params for visual
export default
	name: 'CraftVisual'
	functional: true

	# Get the index of the block this may be in
	inject: blockIndex: default: undefined

	props: {
		...baseProps

		# A support Craft objects with width, height, etc
		image: Object | Array
		video: Object | Array

		# Support additional types
		aspect: Number | String | Boolean

		# Set width and height to natural size
		natural: Boolean

		# Use image's width as a max-width
		noUpscale: Boolean

		# Clear placeholder color, like for logos
		noPlaceholder: Boolean

		# Set base booleans to an undefined default so we can test whether they
		# were explicitly made false or are actually undefined
		lazyload:
			type: Boolean
			default: undefined
		autoplay:
			type: Boolean
			default: undefined
		autopause:
			type: Boolean
			default: undefined
		loop:
			type: Boolean
			default: undefined
		muted:
			type: Boolean
			default: undefined
	}

	# Render a Visual instance
	render: (create, { props, injections, data, children, scopedSlots }) ->

		# Get the assets, either of which is optional
		image = getAssetObject props.image
		video = getAssetObject props.video

		# Get the image src, ignoring srcset for now.  We're using the
		imageUrl = if process.env.IMGIX_URL
			if props.natural then makeImgixUrl image?.path
			else makeImgixUrl image?.path, resizeWidths[0]
		else
			if props.natural then image?.url
			else image?['w' + resizeWidths[0]]

		# Decide if there is a placeholder color
		placeholderColor = if props.noPlaceholder
		then null else defaultPlaceholderColor

		# Figure out the aspect ratio
		aspect = switch
			when props.aspect is false then undefined
			when !props.aspect? then image?.width / image?.height
			when props.aspect and # Convert "16:9" style aspect to a number
				typeof props.aspect == 'string' and
				dimensions = props.aspect?.match /^(\d+):(\d+)$/
				then dimensions[1] / dimensions[2]
			else props.aspect

		# If no asset but an aspect, still create the Visual instance which
		# becomes a placeholder space
		unless image or video
			return unless aspect or children
			return create Visual, { ...data, props: {
				aspect, placeholderColor
			} }, children

		# Passthrough the width and height
		{ width, height } = if props.natural and image then image else props

		# Apply a max-width if no upscale is set
		maxWidth = if props.noUpscale then image?.width

		# Helpers for automatically creating sizes
		sizes = if props.sizes then sizesHelpers props.sizes
		else if width then "#{parseInt(width)}px"

		# Warn developers to specify a sizes prop
		if imageUrl and !sizes and process.env.APP_ENV == 'dev'
		then console.debug "No sizes prop for #{imageUrl}"

		# Were sources created upstream, by, for instance, responsive-craft-visual
		hasSources = !!scopedSlots['image-source']

		# Disable lazy loading automatically if found in 2 blocks. Written
		# kinda weird so it defaults to true when blockIndex is undefined
		notCriticalImage = !(injections.blockIndex < 2)
		lazyload = props.lazyload ? notCriticalImage

		# If transition is undefined and is a crticial image, disable the
		# transition so the visual doesn't begin as display none.
		transition = props.transition ? if notCriticalImage then undefined else ''

		# Instantiate a Visual instance
		create Visual, {
			...data
			props: {

				# Passthrough props by default
				...props

				# Image
				image: imageUrl
				sizes
				...(if hasSources then {} else {
					srcset: makeSrcset image, webp: false, max: width || maxWidth
					webpSrcset: makeSrcset image, webp: true, max: width || maxWidth
				})

				# Video
				video: video?.url
				autoplay: props.autoplay ? true
				loop: props.loop ? true
				muted: props.muted ? true

				# Layout
				aspect
				width
				height
				maxWidth
				objectPosition: makeObjectPosition props.objectPosition, image

				# Loading
				lazyload
				transition
				placeholderColor
				intersectionOptions: props.intersectionOptions ?
					rootMargin: '50% 0% 50% 0%'

				# Accessibility
				alt: image?.title || video?.title
		}}, children

# Craft returns assets in an array, so get the first asset in the list
export getAssetObject = (asset) ->
	if Array.isArray asset
		if asset.length
		then return asset[0]
		else return null
	return asset

export getObjectPositionFromFocalPoint = (focalPoint) ->
	return unless focalPoint?.length == 2
	"#{focalPoint[0] * 100}% #{focalPoint[1] * 100}%"

# Make a CSS background position value
makeObjectPosition = (objectPosition, image) ->
	objectPosition || getObjectPositionFromFocalPoint(image?.focalPoint) || '50% 50%'

# The srcset values need to match those used in transforms in the query
export makeSrcset = (image, { webp, max } = {}) ->
	return unless image

	# Passthru gifs, currently ignoring imgix for this
	if image.mimeType == 'image/gif' then return image.url

	# Don't make srcs if the there is max width restriction
	sizes = unless max then resizeWidths
	else
		maxWidth = 2 * parseInt max
		resizeWidths.filter (size) -> size <= maxWidth

	# Make the srcset string
	srcSet = sizes.map (size) ->

		# Make URLs through imgix
		if process.env.IMGIX_URL
			"#{encodeURI(makeImgixUrl(image.path, size))} #{size}w"

		# Else use Craft transforms
		else
			srcKey = "w#{size}"
			srcKey += '_webp' if webp
			"#{url} #{size}w" if url = image[srcKey]

	# Filter out empties, for instance webps will be empty for svgs
	.filter (val) -> !!val
	.join ','

# Make sizes shorthands
export sizesHelpers = (sizes) -> switch sizes
	when '4 column' then '''
			(min-width: 1440px) 360px,
			(max-width: 767px) 100vw,
			(max-width: 1023px) 50vw,
			(max-width: 1190px) 33vw,
			25vw
		'''
	when '3 column' then '''
			(min-width: 1440px) 480px,
			(max-width: 767px) 100vw,
			(max-width: 1023px) 50vw,
			33vw
		'''
	when '2/3 column' then '''
			(min-width: 1440px) 960px,
			(max-width: 1023px) 100vw,
			66vw
		'''
	else sizes
