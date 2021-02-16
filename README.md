# Ghillie

## Usage

From your project's `nuxt.config.coffee`:

```coffee
# Make boilerplate
{ mergeConfig, makeBoilerplate } = require '@bkwld/ghillie'
boilerplate = makeBoilerplate
	siteName: 'My Site'

# Merge boilerplate in with project specific config
module.exports = mergeConfig boilerplate,

	# Customize routes
	router: extendRoutes: (routes, resolve) ->

		# Make all path params required in detail routes
		detailRoutes = ['blog-tag-tag', 'blog-category-article']
		routes.filter ({ name }) -> name in detailRoutes
		.forEach (route) -> route.path = route.path.replace /\?/g, ''

		# Append the boilerplate routes
		return boilerplate.router.extendRoutes routes, resolve
```

## Boilerplate - Options

These are options you can pass to `makeBoilerplate`.  See the [source code](config/boilerplate.coffee) for defaults.

| Property | Description |
| -------- | ----------- |
| `siteName` | Name of site gets prepended to the `<title>` and used in PWA manifest. |
| `polyfills` | Array of [polyfill.io](https://polyfill.io/) keywords, for example `URL`. |

## Notes

- Using `cjs` module syntax for to make developing via yarn link simpler.  I tried using `esm` package but it ran into issues with imports of imports.
