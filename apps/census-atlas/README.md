# Census Atlas

Census Atlas is a responsive, accessible dashboard for exploring U.S. Census
American Community Survey (ACS) 5-year estimates. It runs as a static web app,
attempts direct queries to the public Census Data API, and includes a clearly
labeled demo fallback so the interface remains explorable when the API is
unavailable or requires a key.

## Features

- State and county profiles with URL-shareable filters
- Search across states, loaded counties, measures, and Census table identifiers
- Topic catalog covering population, race and ethnicity, income, housing, education, employment, families, language, birthplace, transportation, and health coverage
- State and county map explorer with 21 measures, year controls, hover values, distributions, and highest/lowest rankings
- Eight headline indicators with margins of error
- State or national benchmark context for every place profile
- Six-year trends for population and median household income
- Demographic, housing, education, employment, and poverty breakdowns
- Side-by-side state and county comparison
- Custom Data Explorer for up to 20 ACS detailed-table variable codes
- CSV and JSON export
- Dark/light theme, keyboard navigation, reduced-motion support, and responsive layout
- No account or backend required for the bundled demo experience
- Optional per-tab API key entry for live Census data; keys are never persisted

## Run locally

```bash
npm start
```

Open <http://localhost:4173>.

## Test

```bash
npm run check
```

The suite covers Census response parsing, calculations, formatting, query
construction, CSV export, and output escaping.

## Data and methodology

Live mode uses the U.S. Census Bureau ACS 5-year Detailed Tables API. Estimates
are accompanied by their published 90% margins of error where available.
Values shown as rates are calculated from published numerator and denominator
estimates and may differ slightly from Census profile-table values due to
rounding. ACS estimates are not a population census and should not be treated
as exact counts. Adjacent ACS 5-year releases overlap by four survey years, so
the app presents them as a recent trend rather than independent periods.

The geographic choropleth uses Census-derived `us-atlas` state and county
geometry and locally bundled map code. Fonts and map assets are served with the
site; Census values still come directly from `api.census.gov`. If the geometry
assets cannot load, the accessible tile-map fallback remains available.

The Census Bureau may require an API key for production requests. This static
release never embeds a shared secret in browser code. Visitors can provide their
own Census API key; it is held only in page memory, sent directly to
`api.census.gov` as a query parameter, and removed when the page closes or
reloads. The Census Bureau may log those requests. The key is not placed in the
page URL, analytics, exports, or source control. If no key is present or a request is
rejected, the status bar changes to orange and every fallback place name is
marked “demo profile.” A shared-key deployment should instead use a server-side
proxy and keep `CENSUS_API_KEY` in that host's secret manager.

## Deployment

The production artifact is the `dist/` directory. Run `npm ci && npm run check`
before deploying; this builds the local map and font assets and runs tests. The
site can be hosted on any static host.

### GitHub Pages

The included `pages.yml` workflow publishes `dist/` whenever `main` is pushed.
In the repository's **Settings → Pages** screen, set the deployment source to
**GitHub Actions**. The public project URL will be:

<https://jibekgupta.github.io/census-dashboard/>

## Privacy

The app has no accounts, cookies, analytics, or server-side storage. A Census
API key is never stored by Census Atlas; it remains in page memory until the
page closes or reloads. The color-theme preference is saved in local browser
storage, and geography filters can be included in a shareable URL. Census
requests, including a supplied key, go directly from the browser to
`api.census.gov` over HTTPS. The page has a content security policy that limits
scripts and asset loading to this site and Census API requests to the Census
Bureau. The browser is instructed not to cache Census API responses or send a
referrer with those requests.

## License

MIT. Census data is public-domain U.S. government data. This project is not
affiliated with or endorsed by the U.S. Census Bureau.
