# Render rich text content from Contentful
import RichTextRenderer from 'contentful-rich-text-vue-renderer'
import { INLINES, BLOCKS } from '@contentful/rich-text-types'

# ContentfulVisual used to render image assets
import ContentfulVisual from '../contentful-visual'

# Query to get embedded assets
import getEmbeddedAsset from './embedded-asset.gql'

export default

	# Pass the JSON in
	props:
		doc: Object

		# Support passing in the query and renderer for embedded entries
		embededEntriesQuery: String
		embededEntriesRenderer: Function

		# Enable these directives. They are expected to already be globally
		# imported
		unorphan: Boolean
		balanceText: Boolean

		# Optional.  For manually setting the fetchKey to something unique
		# to each component instance.  Use this if you're getting Nuxt fetch key
		# conflicts.  This can happen after client-side navigation in static mode.
		# Can cause your rich-text 'links' to get nulled out, or the message
		# to appear: "Missing renderer for undefined".
		fetchKey: String

	data: -> links: {}

	fetchKey: (getCounter) -> @fetchKey or getCounter()

	# Fetch linked entries
	fetch: ->

		# Get every linked entry's id for rich text block
		linkedEntries = @getLinkedEntries @docJson
		return unless linkedEntries?.length

		# Query Contentful for embeddable entries based off id
		fetchedLinks = await Promise.all linkedEntries.map ({id, nodeType}) =>
			switch nodeType

				# Embedded entries
				when 'embedded-entry-block', 'embedded-entry-inline'
					@$contentful.getEntry
						query: @embededEntriesQuery
						variables: { id }

				# Query for embedded assets since assets aren't "entry" types
				when "embedded-asset-block"
					@$contentful.getEntry
						query: getEmbeddedAsset
						variables: { id }

		# Create an object of all links
		@links = fetchedLinks.reduce (links, link) ->
			links[link.id] = link if link?.id
			return links
		, {}

	computed:

		# Get the JSON from the passed in field data
		docJson: -> @doc?.json || @doc

	methods:

		# Node renderer schema
		renderNodes: ->
			[INLINES.EMBEDDED_ENTRY]: @renderEmbedded
			[BLOCKS.EMBEDDED_ENTRY]: @renderEmbedded
			[BLOCKS.EMBEDDED_ASSET]: @renderAsset
			break: (_node, key, create) -> create('br', {key}, {})
			# Use renderTextBlock() for elements that should convert \n to <br>
			[BLOCKS.HEADING_1]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'h1')
			[BLOCKS.HEADING_2]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'h2')
			[BLOCKS.HEADING_3]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'h3')
			[BLOCKS.HEADING_4]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'h4')
			[BLOCKS.HEADING_5]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'h5')
			[BLOCKS.HEADING_6]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'h6')
			[BLOCKS.PARAGRAPH]: (node, key, create, next) => @renderTextBlock(node, key, create, next, 'p')
			[BLOCKS.TABLE]: (node, key, create, next) => @wrapElement('table', {class: 'table-wrapper'}, node, key, create, next)
			[BLOCKS.TABLE_ROW]: (node, key, create, next) => create('tr', { key }, next(node.content, key, create, next))
			[BLOCKS.TABLE_CELL]: (node, key, create, next) => create('td', { key }, next(node.content, key, create, next))
			[BLOCKS.TABLE_HEADER_CELL]: (node, key, create, next) => create('th', { key }, next(node.content, key, create, next))

		# Render function that wraps a div around an element
		wrapElement: (elementTag, wrapperData, node, key, create, next) ->
			element = create(elementTag, {key}, next(node.content, key, create, next))
			create 'div', wrapperData, [element]

		# Render function for text blocks
		renderTextBlock: (node, key, create, next, element) ->
			# Convert \n to <br>
			content = @getNodeContentWithNewline({ node, key })

			# Render it
			return create(element, { key }, next(content, key, create, next))

		# Convert "\n" strings into <br> nodes
		# If `node` arg is a text node that contains instances of "\n",
		# convert it to an array of text nodes with "br" nodes in between.
		# Fixes behavior where adding soft return in Contentful (shift + enter)
		# had no effect on the front end.
		# https://github.com/paramander/contentful-rich-text-vue-renderer/issues/29
		# https://codesandbox.io/s/delicate-shadow-81xs7?file=/src/App.vue
		getNodeContentWithNewline: ({ node, key }) ->
			nodeContentWithNewlineBr = node.content.map (childNode) ->
				if childNode.nodeType == "text"
					splittedValue = childNode.value.split "\n"
					return splittedValue
						.reduce(
							(aggregate, v, i) -> [
								...aggregate
								{ ...childNode, value: v }
								{ nodeType: "break", key: "#{key}-br-#{i}" },
							],
							[]
						)
						.slice(0, -1)
				return childNode
			return [].concat.apply([], nodeContentWithNewlineBr);

		# Renderer function for embedded blocks
		renderEmbedded: (node, key, create) ->
			return if not targetId = node?.data?.target?.sys?.id

			# Get target data from links query
			entry = @links[targetId]
			contentType = entry?.__typename

			# Try to render the emebdded entry
			if vm = @embededEntriesRenderer { create, contentType, entry, key }
			then return vm

			# Otherwise, render a span with a warning message
			create 'span', {}, "Missing renderer for #{contentType}"

		# Renderer function for embedded assets
		renderAsset: (node, key, create) ->
			return if not targetId = node?.data?.target?.sys?.id

			# Get target data from links query
			image = @links[targetId]

			# Make the visual instance, using Natural because the expectation is
			# that this is used to render logos.
			create ContentfulVisual, {
				key,
				props:
					image: image
					natural: true
			}

		# Reduce the doc to just linked entry ids and node types for querying
		getLinkedEntries: (entry) ->
			return if not content = entry?.content
			content.reduce (entries, listedEntry) =>

				# Add the type and id to the list
				id = listedEntry?.data?.target?.sys?.id
				nodeType = listedEntry?.nodeType
				entries.push({ id, nodeType }) if id

				# Recurse though children
				if listedEntry?.content?.length
					sublinks = @getLinkedEntries listedEntry
					entries.push(...sublinks)

				# Return the entries we've discovered
				return entries
			, []

	# Render the rich text document
	render: (create) ->

		# Don't render until fetch has resolved
		return if @$fetchState.pending

		# Wrap in a div to apply containing functionality
		create 'div', {

			# Automatically add directives
			directives: [
				{ name: 'parse-anchors' }
				{ name: 'unorphan' } if @unorphan
				{ name: 'balance-text', modifiers: children: true } if @balanceText
			].filter (val) -> !!val

			# Append the WYSIWYG class
			class: wysiwyg: true

		# Nest the rich text component
		}, create RichTextRenderer,
			props:
				nodeRenderers: @renderNodes()
				document: @docJson
