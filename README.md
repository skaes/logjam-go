# logjam-go

Just some code to create install-able go packages for the logjam build pipeline.

[![build](https://github.com/skaes/logjam-go/actions/workflows/build.yml/badge.svg)](https://github.com/skaes/logjam-go/actions/workflows/build.yml)

## Usage

Edit file `versions.yml`, change the version number the download SHA and push to Github.

The GitHub Actions pipeline will then build go packages for Focal, Bionic and Xenial and
upload them to [railsexpress.de](https://railsexpress.de/packages/ubuntu/).

To create the packages locally, run `make packages`.
