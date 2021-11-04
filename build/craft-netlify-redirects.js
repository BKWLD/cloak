/*
A Nuxt module that appends redirects that don't end in an anchor to the
_redirects file
*/
import axios from 'axios'
import { resolve } from 'path'
import { existsSync, readFileSync, writeFileSync } from 'fs'

// Query for redirects
const getEntries = `query getRedirects(($site:[String])) {
	entries(type:"redirects", site:$site) {
		... on redirects_redirects_Entry {
			from: redirectFrom
			to: redirectTo
			code: redirectCode
		}
	}
}`

// Trigger after the static files are copied to the dist, that's the version
// that will get edited
export default function() {
	this.nuxt.hook('generate:distCopied', async (builder) => {
		console.log('  Adding server side redirects');

		// Open up _redirects
		const file = resolve(this.nuxt.options.srcDir, 'dist/_redirects')
		let redirects = existsSync(file) ? readFileSync(file, 'utf8') : ''
		
		// Fetch the server side redirects
		const response = await axios({
			url: process.env.CMS_ENDPOINT,
			method: 'post',
			headers: {
				'Content-Type': 'application/json'
			},
			data: {				query: getEntries,
				variables: {
					site: process.env.CMS_SITE || null
				}
			}
		});

		// Write redirects file back out
		response.data.data.entries.forEach(rule => {
			redirects += `\n${rule.from} ${rule.to} ${rule.code}!`;
		})
		writeFileSync(file, redirects);
	});
};
