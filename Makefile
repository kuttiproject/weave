IMAGE_VERSION ?= 0.1.0
REGISTRY_USER ?= kuttiproject

ALPINE_BASEIMAGE ?= alpine:3.20.2

PLATFORMS ?= linux/amd64,linux/arm,linux/arm64,linux/ppc64le,linux/s390x

# Targets
.PHONY: build-images
build-images: 
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	PLATFORMS="$$(docker version -f '{{ .Server.Arch }}')" \
	ALPINE_BASEIMAGE=$(ALPINE_BASEIMAGE) \
	PUBLISH=false \
	scripts/build-images.sh

.PHONY: build
build: build-images

.PHONY: publish-images
publish-images: 
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	PLATFORMS="$(PLATFORMS)" \
	ALPINE_BASEIMAGE=$(ALPINE_BASEIMAGE) \
	PUBLISH=true \
	scripts/build-images.sh

.PHONY: publish
publish: publish-images

.PHONY: clean-images
clean-images:
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	scripts/clean-images.sh

.PHONY: clean
clean: clean-images

.PHONY: scan
scan:
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	scripts/scan-images.sh

.PHONY: clean-scan
clean-scan:
	scripts/clean-scans.sh
