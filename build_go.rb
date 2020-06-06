name "logjam-go"

v, i = File.read(File.expand_path(__dir__)+"/VERSION").chomp.split('-')
version v
iteration i

vendor "skaes@railsexpress.de"

source "https://golang.org/dl/go#{version}.linux-amd64.tar.gz",
       checksum: "aed845e4185a0b2a3c3d5e1d0a35491702c55889192bb9c30e67a3de6849c067"

run "mv", "go", "/usr/local"
run "ln", "-s", "/usr/local/go/bin/go", "/usr/local/bin/go"
run "ln", "-s", "/usr/local/go/bin/godoc", "/usr/local/bin/godoc"
run "ln", "-s", "/usr/local/go/bin/gofmt", "/usr/local/bin/gofmt"
