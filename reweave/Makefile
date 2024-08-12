IMAGE_VERSION ?= 2.8.9-beta2
REGISTRY_USER ?= kuttiproject

ALPINE_BASEIMAGE ?= alpine:3.20.2

# Targets
.PHONY: build-images
build-images: 
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	PLATFORMS="$$(docker version -f '{{ .Server.Arch }}')" \
	ALPINE_BASEIMAGE=$(ALPINE_BASEIMAGE) \
	PUBLISH=false \
	tools/build-images.sh

.PHONY: build
build: build-images

.PHONY: publish-images
publish-images: 
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	PLATFORMS="linux/amd64" \
	ALPINE_BASEIMAGE=$(ALPINE_BASEIMAGE) \
	PUBLISH=true \
	tools/build-images.sh

.PHONY: publish
publish: publish-images

.PHONY: clean-images
clean-images:
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	tools/clean-images.sh

.PHONY: clean
clean: clean-images

.PHONY: scan
scan:
	REGISTRY_USER=${REGISTRY_USER} IMAGE_VERSION=${IMAGE_VERSION} \
	tools/scan-images.sh

.PHONY: clean-scan
clean-scan:
	tools/clean-scans.sh
