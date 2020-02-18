name "logjam-go"

v, i = File.read(File.expand_path(__dir__)+"/VERSION").chomp.split('-')
version v
iteration i

vendor "skaes@railsexpress.de"

source "https://golang.org/dl/go#{version}.linux-amd64.tar.gz",
       checksum: "0567734d558aef19112f2b2873caa0c600f1b4a5827930eb5a7f35235219e9d8"

run "mv", "go", "/usr/local"
run "ln", "-s", "/usr/local/go/bin/go", "/usr/local/bin/go"
run "ln", "-s", "/usr/local/go/bin/godoc", "/usr/local/bin/godoc"
run "ln", "-s", "/usr/local/go/bin/gofmt", "/usr/local/bin/gofmt"
