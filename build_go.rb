name "logjam-go"

version_info = YAML::load_file(File.expand_path(__dir__)+"/version.yml")
package_version, checksum = version_info.values_at(*%w(package checksum))

v, i = package_version.split('-')
version v
iteration i

vendor "skaes@railsexpress.de"

source "https://golang.org/dl/go#{version}.linux-amd64.tar.gz", checksum: checksum

run "mkdir", "-p", "/usr/local/go"
run "mv", "*", "/usr/local/go"
run "ln", "-s", "/usr/local/go/bin/go", "/usr/local/bin/go"
run "ln", "-s", "/usr/local/go/bin/godoc", "/usr/local/bin/godoc"
run "ln", "-s", "/usr/local/go/bin/gofmt", "/usr/local/bin/gofmt"
