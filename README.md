# logjam-go

Just some code to create install-able go packages for the logjam build pipeline.

## Usage

Edit file `VERSION`, change the version number, edit file `build_go.rb` and change the
download SHA and push to Github.

The travis pipeline will then build go packages for Bionic and Xenial and upload them to
railsexpress.de.

To create the packages locally, run `make packages`.
