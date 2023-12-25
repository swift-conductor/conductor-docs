#!/usr/bin/env bash

# activate virtual environment
source .venv/bin/activate

pushd gh-pages/conductor-docs-gh-pages
git pull
mkdocs gh-deploy --config-file ../../mkdocs.yml --remote-branch gh-pages
popd

