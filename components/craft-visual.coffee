# Load cloak-visual
import CloakVisual, { resizeWidths } from './cloak-visual'

# We may be using imgix
import { makeImgixUrl } from '../services/helpers'

# Map Craft image objects into params for visual
export default
	name: 'CraftVisual'
	functional: true

	# Support all CloakVisual props
	props: {
		...CloakVisual.props

		# A support Craft objects that typically arrive as arrays
		image: Object | Array
		video: Object | Array
	}

	# Render a Visual instance
	render: (create, { props, data, children, scopedSlots }) ->

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

		# Figure out the aspect ratio
		aspect = switch
			when props.aspect is false then undefined
			when !props.aspect? then image?.width / image?.height
			else props.aspect

		# Passthrough the width and height
		{ width, height } = if props.natural and image then image else props

		# Apply a max-width if no upscale is set
		maxWidth = if props.noUpscale then image?.width

		# Were sources created upstream, by, for instance responsive-*-visual
		hasSources = !!scopedSlots['image-source']

		# Don't make src-sets for vector images or gifs
		noSrcset = !!image?.mimeType?.match(/image\/(svg|gif)/i)

		# Instantiate a Visual instance
		create CloakVisual, {
			...data
			props: {

				# Passthrough props by default
				...props

				# Image
				image: imageUrl
				...(if hasSources || noSrcset then {} else {
					srcset: makeSrcset image, webp: false, max: width || maxWidth
					webpSrcset: makeSrcset image, webp: true, max: width || maxWidth
				})

				# Video
				video: video?.url

				# Layout
				aspect
				width
				height
				maxWidth
				objectPosition: makeObjectPosition props.objectPosition, image

				# Accessibility
				alt: image?.title || video?.title

		# Passthrough slot
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

	# Don't output src options that are greater then a 2X version of the max width
	sizes = unless max then resizeWidths
	else
		maxWidth = 2 * parseInt max
		resizeWidths.filter (size) -> size <= maxWidth

	# Make the srcset string
	sizes.map (size) ->

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
