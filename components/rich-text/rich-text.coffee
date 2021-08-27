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

	data: -> links: {}

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
