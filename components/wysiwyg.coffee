# Render HTML content from craft
export default
	name: 'WYSIWYG'
	functional: true

	# Pass the HTML in
	props:
		html: String

		# Enable these directives. They are expected to already be globally
		# imported
		unorphan: Boolean
		balanceText: Boolean

	# Render a div with wsywiyg class and props
	render: (create, { props, data }) ->
		return unless props.html
		create 'div', {
			...data

			# Automatically add directives
			directives: [
				{ name: 'parse-anchors' }
				{ name: 'unorphan' } if props.unorphan
				{ name: 'balance-text', modifiers: children: true } if props.balanceText
			].filter (val) -> !!val

			# Append the WYSIWYG class
			staticClass: ['wysiwyg', data.staticClass].join(' ').trim()

			# Render the HTML
			domProps: innerHTML: wrapTables props.html
		}

# Add a wrapping div around HTML instances so they can be horizontally scrolled
wrapTables = (html) ->
	html
	.replace '<table>', '<div class="table-wrap"><table>'
	.replace '</table>', '</table></div>'
