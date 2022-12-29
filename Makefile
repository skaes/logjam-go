.PHONY: packages clean

.DEFAULT: packages

clean:
	docker ps -a | awk '/Exited/ {print $$1;}' | xargs docker rm
	docker images | awk '/none|fpm-(fry|dockery)/ {print $$3;}' | xargs docker rmi

PACKAGES:=package-bionic package-focal package-jammy
.PHONY: packages $(PACKAGES)

packages: $(PACKAGES)

define build-package
  RUBYOPT='-W0' bundle exec fpm-fry cook --update=always ubuntu:$(1) build_go.rb
  mkdir -p packages/ubuntu/$(1) && mv *.deb packages/ubuntu/$(1)
endef

package-bionic:
	$(call build-package,bionic)
package-focal:
	$(call build-package,focal)
package-jammy:
	$(call build-package,jammy)

LOGJAM_PACKAGE_HOST:=railsexpress.de
LOGJAM_PACKAGE_USER:=uploader

.PHONY: publish publish-bionic publish-focal publish-jammy
publish: publish-bionic publish-focal publish-jammy

VERSION:=$(shell awk '/package:/ {print $$2};' version.yml)
PACKAGE_NAME:=logjam-go_$(VERSION)_amd64.deb

define upload-package
@if ssh $(LOGJAM_PACKAGE_USER)@$(LOGJAM_PACKAGE_HOST) debian-package-exists $(1) $(2); then\
  echo package $(1)/$(2) already exists on the server;\
else\
  tmpdir=`ssh $(LOGJAM_PACKAGE_USER)@$(LOGJAM_PACKAGE_HOST) mktemp -d` &&\
  rsync -vrlptDz -e "ssh -l $(LOGJAM_PACKAGE_USER)" packages/ubuntu/$(1)/$(2) $(LOGJAM_PACKAGE_HOST):$$tmpdir &&\
  ssh $(LOGJAM_PACKAGE_USER)@$(LOGJAM_PACKAGE_HOST) add-new-debian-packages $(1) $$tmpdir;\
fi
endef


publish-bionic:
	$(call upload-package,bionic,$(PACKAGE_NAME))

publish-focal:
	$(call upload-package,focal,$(PACKAGE_NAME))

publish-jammy:
	$(call upload-package,jammy,$(PACKAGE_NAME))
