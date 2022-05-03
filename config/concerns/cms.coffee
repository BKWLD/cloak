###
Add configuration required to interact with CMS choice
###
{ join } = require 'path'
{ getAccessToken } = require '../../services/contentful'
module.exports = ({ cms }) ->
	return unless cms

	env: {
		CMS: cms

		# CMS service connection info
		...(
			switch cms
				when 'craft'
					CMS_ENDPOINT: process.env.CMS_ENDPOINT
					CMS_SITE: process.env.CMS_SITE
				when 'contentful'
					CONTENTFUL_SPACE: process.env.CONTENTFUL_SPACE
					CONTENTFUL_PREVIEW: process.env.CONTENTFUL_PREVIEW

					# Don't expose the preview access token when it's not being used
					CONTENTFUL_ACCESS_TOKEN: getAccessToken()

		)
	}

	# Adds the cms service plugin
	modules: [
		[ join(__dirname, '../../modules/register-cms-service'), { cms }]
	] if cms in [ 'craft' , 'contentful' ]
