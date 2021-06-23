# Deps
import CloakVisual, { resizeWidths } from './cloak-visual'
import { makeContentfulImageUrl } from '../services/helpers'

# Map Contentful image objects into params for visual
export default
	name: 'ContentfulVisual'
	functional: true

	# Support all CloakVisual props
	props: {
		...CloakVisual.props

		# A support Contentful objects with width, height, etc
		image: Object
		video: Object
	}

	# Render a Visual instance
	render: (create, { props, data, children, scopedSlots }) ->

		# Make shorter accessors
		image = props.image
		video = props.video

		# Get the image src, ignoring srcset for now.  We're using the
		imageUrl = if props.natural then image?.url
		else makeContentfulImageUrl image?.url, resizeWidths[0]

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

		# Instantiate a Visual instance
		create CloakVisual, {
			...data
			props: {

				# Passthrough props by default
				...props

				# Image
				image: imageUrl
				...(if hasSources then {} else {
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

				# Accessibility
				alt: image?.description ||
					image?.title ||
					video?.description ||
					video?.title

		# Passthrough slot
		}}, children

# The srcset values need to match those used in transforms in the query
export makeSrcset = (image, { webp, max } = {}) ->
	return unless image

	# Passthru gifs, currently ignoring imgix for this
	if image.contentType == 'image/gif' then return image.url

	# Don't output src options that are greater then a 2X version of the max width
	sizes = unless max then resizeWidths
	else
		maxWidth = 2 * parseInt max
		resizeWidths.filter (size) -> size <= maxWidth

	# Set webp format
	options = if webp then { format: 'webp' }

	# Make the srcset string
	sizes.map (size) ->
		"#{encodeURI(makeContentfulImageUrl(image.url, size, options))} #{size}w"
	.join ','
