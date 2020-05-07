name "logjam-go"

v, i = File.read(File.expand_path(__dir__)+"/VERSION").chomp.split('-')
version v
iteration i

vendor "skaes@railsexpress.de"

source "https://golang.org/dl/go#{version}.linux-amd64.tar.gz",
       checksum: "6272d6e940ecb71ea5636ddb5fab3933e087c1356173c61f4a803895e947ebb3"

run "mv", "go", "/usr/local"
run "ln", "-s", "/usr/local/go/bin/go", "/usr/local/bin/go"
run "ln", "-s", "/usr/local/go/bin/godoc", "/usr/local/bin/godoc"
run "ln", "-s", "/usr/local/go/bin/gofmt", "/usr/local/bin/gofmt"
