# Cloak

Opinionated Nuxt + Craft boilerplate.

> Unfinished, don't use yet

![](https://slack-imgs.com/?c=1&o1=ro&url=https%3A%2F%2Fmedia4.giphy.com%2Fmedia%2Ffs616XzKDb6cyd7TMa%2Fgiphy-downsized.gif%3Fcid%3D6104955e248cc15d4c2aeca08bb88c9fb520d40e9552a715%26rid%3Dgiphy-downsized.gif)

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

## Options

These are options you can pass to `makeBoilerplate`.  See the [source code](config/boilerplate.coffee) for defaults.

| Property | Description |
| -------- | ----------- |
| `siteName` | Name of site gets prepended to the `<title>` and used in PWA manifest. |
| `polyfills` | Array of [polyfill.io](https://polyfill.io/) keywords, for example `URL`. |
| `pageTypenames` | Array of Craft `_typename` values for page sections. These will be queried nad turned into routes. |
| `imgixUrl` | For example, `https://project.imgix.net` |

## Libraries

Besides providing a bunch of nuxt.config boilerplate, this project also provides these shared resources:

- [components](./components) - Vue components that are already setup for autodiscovery with no prefixing.
- [fragments](./fragments) - GraphQL fragments for common objects
- [mixins](./mixins) - Vue mixins
- [services](./services) - Libraries of methods that can be imported into your code and which are also injected globally.  For example, `@$craft` and `@$defer` are available in all components.

## Notes

- Using `cjs` module syntax for to make developing via yarn link simpler.  I tried using `esm` package but it ran into issues with imports of imports.
- Using [a fork](https://github.com/samsarahq/graphql-loader/pull/36) of `webpack-graphql-loader` to work around issues with the loader not being found from the root package. I think because it referenced some old and unecessary deps.
- Use the `Page View` dataLayer event for firing Page View style tags from GTM
