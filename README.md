# logjam-go

Just some code to create install-able go packages for the logjam build pipeline.

## Usage

Edit `build_go.rb`, change the version numbers and download sha and push to github.

The travis pipeline will then build go packages for Bionic and Xenial.

To create the package locally, run `make packages`.
