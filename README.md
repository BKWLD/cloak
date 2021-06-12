# Cloak

Opinionated Nuxt boilerplate with support for Craft and Contentful.

![](https://slack-imgs.com/?c=1&o1=ro&url=https%3A%2F%2Fmedia4.giphy.com%2Fmedia%2Ffs616XzKDb6cyd7TMa%2Fgiphy-downsized.gif%3Fcid%3D6104955e248cc15d4c2aeca08bb88c9fb520d40e9552a715%26rid%3Dgiphy-downsized.gif)

## Install

1. Copy the [scaffold](./scaffold) contents to your project
2. Make a package.json that includes Nuxt and Cloak: `yarn add nuxt @bkwld/cloak`

## Usage

From your project's `nuxt.config.coffee`:

```coffee
# Make boilerplate, setting some options
{ mergeConfig, makeBoilerplate } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
  siteName: 'My Site'
  cms: 'craft'
  pageTypes: ['towers_towers_Entry']

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

#### General

| Property | Description |
| -------- | ----------- |
| `siteName` | Name of site gets prepended to the `<title>` and used in PWA manifest. |
| `polyfills` | Array of [polyfill.io](https://polyfill.io/) keywords, for example `URL`. |
| `repoName` | The Sentry webpack plugin's [repo](https://github.com/getsentry/sentry-webpack-plugin#optionssetcommits) value, for example `Group Name / Project Name`. |

#### CMS

| Property | Description |
| -------- | ----------- |
| `cms` | May be empty, `craft`, or `contentful`. |
| `pageTypes` (if Craft) | An array of Craft `_typename` values. If the `contnetful`, this should be an array of objects like this: `contentType` ids for models taht represent pages. These will be queried and turned into routes. |
| `pageTypes` (if Contentful) | An array of objects with the following properties: `contentType` (a Contentful contentType string), `routeField` (the field that holds the value you'll use in your route, defaults to `"slug"`), and `route` (a function that is passed the value from the `routeField` and which should return a route path). |

#### Visual

| Property | Description |
| -------- | ----------- |
| `imgixUrl` | For example, `https://project.imgix.net` |
| `srcsetWidths` | Array of integer widths that are used to make the Visual srcSet. |
| `placeholderColor` | The default placeholder color for Visual |

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
