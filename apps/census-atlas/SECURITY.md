# Security

## Supported version

The latest deployed version is supported.

## Reporting

Please report a suspected vulnerability privately to the repository owner rather
than opening a public issue. Include reproduction steps and the affected URL or
file. Do not include Census API keys, tokens, or personal information.

## Data handling

Census Atlas does not collect user data. It stores only a color-theme preference
in local browser storage. Geography filters are encoded in the URL for sharing.
User-supplied Census API keys stay only in page memory and are sent directly to
the Census Bureau as query parameters for API requests. The Census Bureau may
log those requests. Keys are never stored by Census Atlas and
are cleared when the page closes or reloads. Shared production API keys must
never be added to `dist/`, committed to Git, or sent to the browser.

The site serves its map code, boundaries, and fonts locally. A content security
policy restricts script sources and network connections. GitHub Pages does not
provide a way for this repository to set custom response security headers, so
the policy is delivered through an HTML meta element; it cannot enforce every
header-only directive, such as `frame-ancestors`.
