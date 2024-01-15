![Swift Conductor](docs/img/logo.svg)

# Swift Conductor Documentation

This is the mkdocs source for the Swift Conductor documentation site hosted at https://swiftconductor.com.

# Edit

```bash
source configure.sh
./watch.sh
```

# Publish

Clone the `conductor-docs-gh-pages` repo:

```bash
mkdir -p gh-pages
git clone git@github.com:swift-conductor/conductor-docs-gh-pages.git gh-pages/conductor-docs-gh-pages
```

Publish to the `gh-pages` branch of `conductor-docs-gh-pages`:

```bash
./publish.sh
```