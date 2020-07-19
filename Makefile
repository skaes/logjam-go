.PHONY: packages clean

.DEFAULT: packages

clean:
	docker ps -a | awk '/Exited/ {print $$1;}' | xargs docker rm
	docker images | awk '/none|fpm-(fry|dockery)/ {print $$3;}' | xargs docker rmi

PACKAGES:=package-bionic package-xenial package-focal
.PHONY: packages $(PACKAGES)

packages: $(PACKAGES)

package-focal:
	LOGJAM_PREFIX=/opt/logjam bundle exec fpm-fry cook --update=always ubuntu:focal build_go.rb
	mkdir -p packages/ubuntu/focal && mv *.deb packages/ubuntu/focal
package-bionic:
	LOGJAM_PREFIX=/opt/logjam bundle exec fpm-fry cook --update=always ubuntu:bionic build_go.rb
	mkdir -p packages/ubuntu/bionic && mv *.deb packages/ubuntu/bionic
package-xenial:
	LOGJAM_PREFIX=/opt/logjam bundle exec fpm-fry cook --update=always ubuntu:xenial build_go.rb
	mkdir -p packages/ubuntu/xenial && mv *.deb packages/ubuntu/xenial

LOGJAM_PACKAGE_HOST:=railsexpress.de
LOGJAM_PACKAGE_USER:=uploader

.PHONY: publish publish-bionic publish-xenial
publish: publish-bionic publish-xenial

VERSION:=$(shell cat VERSION)
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

publish-focal:
	$(call upload-package,focal,$(PACKAGE_NAME))

publish-bionic:
	$(call upload-package,bionic,$(PACKAGE_NAME))

publish-xenial:
	$(call upload-package,xenial,$(PACKAGE_NAME))
