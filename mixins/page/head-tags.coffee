###
Populate head tags automatically
###
export default

	# Default to auto generating the head. Implementing through a method for
	# easier subclassing.
	head: -> @buildHead()

	computed:

		# Make accessor for seo data which may live in a supertable or as
		# individaual fields on the page itself
		seo: -> @page.seo?[0] || {
			metaTitle: @page.metaTitle
			metaDescription: @page.metaDescription
			metaImage: @page.metaImage
			robots: @page.robots
		}

	methods:

		# Helper to make head tags. Passed in props are only used if explicit meta
		# values aren't found
		buildHead: ({ title, description, image } = {}) ->

			# If no page, like on error pages, abort
			return unless @page

			# Look for meta tag values
			title = @seo.metaTitle or @page.title or title
			description = @seo.metaDescription or description
			image = switch
				when @seo.metaImage?.length then @seo.metaImage
				when image?.length then image

			# Create the object, filtering empties
			title: title
			link: if process.env.URL then [
				hid: 'canonical'
				rel: 'canonical'
				href: process.env.URL + @$route.path
			]
			meta: [
				@$metaTag 'og:title', title
				@$metaTag 'description', description
				@$metaTag 'og:image', image
				@$metaTag 'robots', @seo.robots?.join ', '
			].filter (tag) -> !!tag?.content
