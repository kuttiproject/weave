.DEFAULT: all
.PHONY: all showbuild exes 

# This specifies the architecture we're building for, in GOARCH format
ARCH?=amd64

# This specifies the architecture we are building on , in GOARCH format
BUILDARCH?=amd64

# A list of all supported architectures here.
# ALL_ARCHITECTURES=amd64 arm arm64 ppc64le s390x
ALL_ARCHITECTURES=amd64 arm64

# The default version that's chosen when pushing the images. Can/should
# be overridden
WEAVE_VERSION?=git-$(shell git rev-parse --short=12 HEAD)

# Paths to all relevant binaries that should be compiled
WEAVER_EXE=../../cmd/weaver/weaver
KUBEUTILS_EXE=../../cmd/kube-utils/kube-utils
WEAVENPC_EXE=../../cmd/weave-npc/weave-npc
WEAVEUTIL_EXE=../../cmd/weaveutil/weaveutil

# All binaries together in a list
EXES=$(WEAVER_EXE) $(KUBEUTILS_EXE) $(WEAVENPC_EXE) $(WEAVEUTIL_EXE)

# The flags passed to go build.
# -extldflags -static for making a static binary, 
# -X main.version for telling the Go binary which version it is
# -s -w drop symbol tables used by debuggers (not Go's internal symbol info)
# -tags "osusergo netgo" to use native Go UID and DNS implementations
BUILD_FLAGS=-ldflags "-extldflags -static -X main.version=$(WEAVE_VERSION) -s -w" -tags "osusergo netgo"

# This allows adding up to three extra switches to the -ldflags value inside
# the same string returned by BUILD_FLAGS. Needed because the go tool does
# not combine multiple -ldflags 
define extraldflags
-ldflags "-extldflags -static -X main.version=$(WEAVE_VERSION) $(strip $(1) $(2) $(3)) -s -w" -tags "osusergo netgo"
endef

# Targets
all: showbuild exes

showbuild:
	@echo Build Arch: $(BUILDARCH)
	@echo Target Arch: $(ARCH)

$(WEAVER_EXE) $(WEAVEUTIL_EXE): ../../internal/common/*.go ../../internal/common/*/*.go ../../internal/net/*.go ../../internal/net/*/*.go
$(WEAVER_EXE): ../../internal/router/*.go ../../internal/ipam/*.go ../../internal/ipam/*/*.go ../../internal/db/*.go ../../internal/nameserver/*.go ../../cmd/weaver/*.go
$(WEAVER_EXE): ../../internal/api/*.go ../../internal/plugin/*.go ../../internal/plugin/*/*
$(WEAVER_EXE):  ../../internal/proxy/*.go
$(WEAVEUTIL_EXE): ../../cmd/weaveutil/*.go ../../internal/net/*.go ../../internal/plugin/net/*.go ../../internal/plugin/ipam/*.go ../../internal/db/*.go
$(KUBEUTILS_EXE): ../../cmd/kube-utils/*.go
$(WEAVENPC_EXE): ../../cmd/weave-npc/*.go ../../internal/npc/*.go ../../internal/npc/*/*.go

exes: $(EXES) 

$(WEAVER_EXE) $(KUBEUTILS_EXE) $(WEAVENPC_EXE):
	GOOS=linux GOARCH=$(ARCH) go build $(BUILD_FLAGS) -o $@ ./$(@D)

$(WEAVEUTIL_EXE):
	GOOS=linux GOARCH=$(ARCH) go build $(call extraldflags,-X github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=$(WEAVE_VERSION)) -o $@ ./$(@D)
