# Render HTML content from craft
export default
	name: 'WYSIWYG'
	functional: true

	# Pass the HTML in
	props: html: String

	# Render a div with wsywiyg class and props
	render: (create, { props, data }) ->
		return unless props.html
		create 'div', {
			...data

			# Automatically parse anchors
			directives: [ { name: 'parse-anchors' } ]

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
