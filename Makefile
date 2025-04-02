.PHONY: packages clean

.DEFAULT: packages

clean:
	docker ps -a | awk '/Exited/ {print $$1;}' | xargs docker rm
	docker images | awk '/none|fpm-(fry|dockery)/ {print $$3;}' | xargs docker rmi

PACKAGES:=package-noble package-jammy package-focal
.PHONY: packages $(PACKAGES) pull pull-noble pull-jammy pull-focal

ARCH := amd64

ifeq ($(ARCH),)
PLATFORM :=
LIBARCH :=
else
PLATFORM := --platform $(ARCH)
LIBARCH := $(ARCH:arm64=arm64v8)/
endif

packages: $(PACKAGES)

pull: pull-noble pull-jammy pull-focal

pull-noble:
	docker pull $(PLATFORM) $(LIBARCH)ubuntu:noble
pull-jammy:
	docker pull $(PLATFORM) $(LIBARCH)ubuntu:jammy
pull-focal:
	docker pull $(PLATFORM) $(LIBARCH)ubuntu:focal

define build-package
  RUBYOPT='-W0' bundle exec fpm-fry cook $(PLATFORM) --pull --update=always $(LIBARCH)ubuntu:$(1)
  mkdir -p packages/ubuntu/$(1) && mv *.deb packages/ubuntu/$(1)
endef

package-noble:
	$(call build-package,noble)
package-jammy:
	$(call build-package,jammy)
package-focal:
	$(call build-package,focal)

LOGJAM_PACKAGE_HOST:=railsexpress.de
LOGJAM_PACKAGE_USER:=uploader

.PHONY: publish publish-noble publish-jammy publish-focal
publish: publish-noble publish-jammy publish-focal

VERSION:=$(shell awk '/package:/ {print $$2};' version.yml)
PACKAGE_NAME:=logjam-go_$(VERSION)_$(ARCH).deb

define upload-package
@if ssh $(LOGJAM_PACKAGE_USER)@$(LOGJAM_PACKAGE_HOST) debian-package-exists $(1) $(2); then\
  echo package $(1)/$(2) already exists on the server;\
else\
  tmpdir=`ssh $(LOGJAM_PACKAGE_USER)@$(LOGJAM_PACKAGE_HOST) mktemp -d` &&\
  rsync -vrlptDz -e "ssh -l $(LOGJAM_PACKAGE_USER)" packages/ubuntu/$(1)/$(2) $(LOGJAM_PACKAGE_HOST):$$tmpdir &&\
  ssh $(LOGJAM_PACKAGE_USER)@$(LOGJAM_PACKAGE_HOST) add-new-debian-packages $(1) $$tmpdir;\
fi
endef

publish-noble:
	$(call upload-package,noble,$(PACKAGE_NAME))
publish-jammy:
	$(call upload-package,jammy,$(PACKAGE_NAME))
publish-focal:
	$(call upload-package,focal,$(PACKAGE_NAME))


.PHONY: tag release unrelease

TAG := v$(shell awk '/package:/ {print $$2}' version.yml)

tag:
	git tag -f $(TAG)

release: tag
	git push -f origin HEAD refs/tags/$(TAG)

unrelease:
	git tag -d $(TAG)
	git push origin --delete $(TAG)
