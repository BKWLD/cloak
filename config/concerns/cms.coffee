###
Add configuration required to interact with CMS choice
###
{ join } = require 'path'
module.exports = ({ cms }) ->
	return unless cms

	# The GrapgQL endpoint
	env: switch cms
		when 'craft'
			CMS_ENDPOINT: process.env.CMS_ENDPOINT
			CMS_SITE: process.env.CMS_SITE
		when 'contentful'
			CONTENTFUL_SPACE: process.env.CONTENTFUL_SPACE
			CONTENTFUL_ACCESS_TOKEN: process.env.CONTENTFUL_ACCESS_TOKEN

	# Adds the cms service plugin
	modules: [
		[ join(__dirname, '../../modules/register-cms-service'), { cms }]
	]
