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
		defaultSeo: -> @$store?.state?.globals?.defaultSeo?.seo?[0]
		pageSeo: -> @page?.seo?[0]

	methods:

		# Helper to get SEO object from a source
		getSeo: (source) -> @source?.seo?[0]

		# Helper to make head tags. Passed in props are only used if explicit meta
		# values aren't found.  The expectation is that these values are fallbacks.
		buildHead: ({ title, description, image } = {}) ->

			# If no page, like on error pages, abort
			return unless @page

			# Look for meta tag values
			title = @pageSeo.metaTitle or @page.title or title or
				@defaultSeo.metaTitle
			description = @pageSeo.metaDescription or description or
				@defaultSeo.metaDescription
			image = img(@pageSeo.metaImage) or img(image) or
				img(@defaultSeo.metaImage)
			robots = @pageSeo.robots or @defaultSeo.robots

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
				@$metaTag 'robots', robots?.join ', '
			].filter (tag) -> !!tag?.content

# A helper for accessing image values that may be part of an Array with Craft
img = (field) -> field?[0]?.url or field
