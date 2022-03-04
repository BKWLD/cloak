# Cloak

Opinionated Nuxt boilerplate with support for Craft and Contentful.

![](https://slack-imgs.com/?c=1&o1=ro&url=https%3A%2F%2Fmedia4.giphy.com%2Fmedia%2Ffs616XzKDb6cyd7TMa%2Fgiphy-downsized.gif%3Fcid%3D6104955e248cc15d4c2aeca08bb88c9fb520d40e9552a715%26rid%3Dgiphy-downsized.gif)

## Install

The recommended way to use Cloak is to install it with `yarn create cloak-app`.  This command use [`create-cloak-app`](https://github.com/BKWLD/create-cloak-app) and will scaffold a new Nuxt app that uses Cloak.

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

#### CMS

| Property | Description |
| -------- | ----------- |
| `cms` | May be empty, `craft`, or `contentful`. |
| `pageTypes` *(if Craft)* | An array of Craft `_typename` values. |
| `pageTypes` *(if Contentful)* | An array of objects with the following properties: `contentType` (a Contentful contentType string), `routeField` (the field that holds the value you'll use in your route, defaults to `"slug"`), and `route` (a function that is passed the value from the `routeField` and which should return a route path). |
| `generateOnlyRoutes` | *Craft only.* Typically we generate a gql query per `pageType` that fetches the data for all entries, passing their data into the page components as the payload. Set this to `true` to disable this. You would do this on sites with many entries because this query becomes very expensive for Craft to execute. |

#### Visual

| Property | Description |
| -------- | ----------- |
| `imgixUrl` | For example, `https://project.imgix.net`. |
| `srcsetWidths` | Array of integer widths that are used to make the Visual srcSet. |
| `placeholderColor` | The default placeholder color for Visual. |

## Other Config

#### Contentful

The following ENV variables are expected to use Contentful

| Property | Description |
| -------- | ----------- |
| `CONTENTFUL_SPACE` | The space id. |
| `CONTENTFUL_ACCESS_TOKEN` | The Delivery API access token. |
| `CONTENTFUL_PREVIEW_ACCESS_TOKEN` | The Preview API access token. |
| `CONTENTFUL_PREVIEW` | Set to `true` use the Preview API rather than the Delivery API. Aka, to return draft/changed entries. |

#### Sentry

To enable Sentry logging, you'll need to set the following ENV variables:

| Property | Description |
| -------- | ----------- |
| `SENTRY_DSN` | This will be provided when you create a new project in Sentry. |
| `SENTRY_AUTH_TOKEN` | Get this from [your user API settings](https://sentry.io/settings/account/api/auth-tokens). You need the `org:read` and `project:releases` permissions for the token (per `authToken` docs from [`sentry-webpack-plugin`](https://github.com/getsentry/sentry-webpack-plugin)). |

You also need to create a `.sentryclirc` as [described here](https://docs.sentry.io/product/cli/configuration/#config-defaults).  `create-cloak-app` will have already created this.  Example:

```
[defaults]
org=bukwild
project=my-project
```

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
