/*
A Nuxt module that appends redirects that don't end in an anchor to the
_redirects file
*/
import axios from 'axios'
import { resolve } from 'path'
import { existsSync, readFileSync, writeFileSync } from 'fs'

// Query for redirects
const getEntries = `query getRedirects {
	entries(type:"redirects") {
		... on redirects_redirects_Entry {
			from: redirectFrom
			to: redirectTo
			code: redirectCode
		}
	}
}`

// Trigger after the static files are copied to the dist, that's the version
// that will get edited
export default function redirects() {
	this.nuxt.hook('generate:distCopied', async function (builder) {
		console.log('  Adding server side redirects');

		// Open up _redirects
		const file = resolve(__dirname, '../dist', '_redirects')
		let redirects = ''
		if (existsSync(file)) redirects = readFileSync(file, 'utf8')

		// Fetch the server side redirects
		const response = await axios({
			url: process.env.CMS_ENDPOINT,
			method: 'post',
			headers: {
				'Content-Type': 'application/json'
			},
			data: {
				query: getEntries
			}
		});

		// Write redirects file back out
		response.data.data.entries.forEach(rule => {
			redirects += `\n${rule.from} ${rule.to} ${rule.code}!`;
		})
		writeFileSync(file, redirects);
	});
};
