# Cloak

## Usage

From your project's `nuxt.config.coffee`:

```coffee
# Make boilerplate, setting some options
{ mergeConfig, makeBoilerplate } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
  siteName: 'My Site'
  pageTypenames: ['towers_towers_Entry']

# Merge project specific config with cloak boilerplate
module.exports = mergeConfig boilerplate,

  # Append additional internal routes for vue-routing-anchor-parser
  anchorParser: internalUrls: [
    /^https?:\/\/(www)?\.domain\.com/
  ]

  # Customize routes
  router: extendRoutes: (routes, resolve) ->

    # Make all path params required in detail routes
    detailRoutes = ['blog-tag-tag', 'blog-category-article']
    routes.filter ({ name }) -> name in detailRoutes
    .forEach (route) -> route.path = route.path.replace /\?/g, ''

    # Append routes from boilerplate
    return boilerplate.router.extendRoutes routes, resolve
```

## Boilerplate - Options

These are options you can pass to `makeBoilerplate`.  See the [source code](config/boilerplate.coffee) for defaults.

| Property | Description |
| -------- | ----------- |
| `siteName` | Name of site gets prepended to the `<title>` and used in PWA manifest. |
| `polyfills` | Array of [polyfill.io](https://polyfill.io/) keywords, for example `URL`. |
| `pageTypenames` | Array of Craft `_typename` values for page sections. These will be queried nad turned into routes. |

## Notes

- Using `cjs` module syntax for to make developing via yarn link simpler.  I tried using `esm` package but it ran into issues with imports of imports.
