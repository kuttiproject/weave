# New Build Process

This new build process is based on a multi-stage Dockerfile, which combines the build image Dockerfile and all the template-generated final image Dockerfiles from the [old build process](BUILDING-OLD.md).

> NOTE: The new process currently does not ~~build the weave Docker plugin. Nor does it~~ run any tests. This may change in the future.

The new process is controlled by a Makefile, located at `reweave/Makefile`. This calls scripts located at `reweave/tools`. In the future, we should try to maintain this "harness", and only add/change the scripts as required. So, going forward, all anyone has to do is `cd reweave && make build && make scan`, no matter how the build process is evolved.

## What you need

* Docker v23.0.1 or later
* An account on an image registry, like the Docker Hub
* `make`
* [grype](https://github.com/anchore/grype) 0.59.0 or later for image scanning
* The `tools` directory contents. Run `git submodule update --init`.

## Build steps

### During development

At the start of each development cycle, edit [reweave/Makefile](Makefile) and set `IMAGE_VERSION` should be set to something later than the currently published version, perhaps with a prerelease suffix. Also, set `REGISTRY_USER` to *your* registry user account.

After you make code or configurations changes, run the following in the `reweave` directory:

```bash
make
```

This will build all weave net images for your local platform(single-architecture), tag them with your repo user name, and load them to your local docker engine. 

Once the images are built, you can scan the `weave-kube` and `weave-npc` images by running:

```bash
make scan
```

This will scan the images and generate reports in the [scans](scans/) directory.

### To publish images

1. Change `IMAGE_VERSION` and `REGISTRY_USER` variables in [reweave/Makefile](Makefile) to their final, publishable versions.
2. Build and scan as you would for development.
3. When satisfied, commit and tag your changes. **Do this before the next steps, because git metadata is picked from your repository.**.
4. Login to your registry account using `docker login`.
5. Run the following:

```bash
make publish
```

This will build multi-architecture images, and push them to your registry.

Don't forget to `docker logout` afterwards.

## Build Artifacts

### Multi-stage Dockerfile

The Dockerfile can be found at [reweave/build/Dockerfile](build/Dockerfile). It, and the companion [Makefile](#makefile), build multi-arch images for all weave components.

### Makefile

The Makefile can be found at [reweave/build/Makefile](build/Makefile). It builds all necessary executables. **It is meant be used only in Stage 2 of the build process, and not directly on a development environment.**

## Build Tools

### reweave/Makefile

This makefile controls the build and scan processes. It provides the following parameters:

|Parameter|Description|Default value|
|---|---|---|
|IMAGE_VERSION|The tag part of the name (after `:`) for all weave net images.|*version set in makefile*|
|REGISTRY_USER|The account name (with optional registry name in front) used to tag all weave net images.|`kuttiproject`|
|ALPINE_BASEIMAGE|The qualified name for the base Alpine image used to build all weave net images.|*version set in makefile*|

and the following targets:

|Target|Description|
|---|---|
|build-images|Builds images matching the architecture of the local Docker engine, and loads it into the local Docker engine. This is the default target.|
|publish-images|Builds multi-architecture images for all configured architectures, and pushes them to the registry.|
|clean-images|Removes images from the local docker engine.|
|publish|Same as publish-images.|
|clean|Sames as clean-images.|
|scan|Scans the weave-kube and weave-npc images using the configured scanner (currently grype), and stores the results in `reweave/scans`.|
|clean-scan|Deletes scan results.|

### reweave/tools/build-images.sh

This script invokes `docker buildx build` for each stage from stage 4 onwards. By default, it builds for all supported platforms, tags the image as `kuttiproject/IMAGENAME:CURRENTVERSION`, and keeps them in the build cache. This behavior can be controlled by setting the following environment variables before invoking the script.

|Env Var Name|Description|Default Value|
|---|---|---|
|IMAGE_VERSION|The tag part of the name (after `:`) for all weave net images.|*version set in Makefile*|
|REGISTRY_USER|The account name (with optional registry name in front) used to tag all weave net images.|*user set in Makefile*|
|ALPINE_BASEIMAGE|The qualified name for the base Alpine image used to build all weave net images.|*version set in Makefile*|
|PLATFORMS|Comma-separated list of the target platforms for which the weave net images will be built.|`linux/amd64,linux/arm,linux/arm64,linux/ppc64le,linux/s390x`|
|PUBLISH|Whether to push the images after build (`true`) , or load them to the local Docker engine (`false`). `false` is only possible if PLATFORMS has the same value as the build platform. If left empty, the images will be built in the build cache only.||

### reweave/tools/clean-images.sh

This script deletes the built images from the local Docker engine.

### reweave/tools/scan-images.sh

This script scans the weave-kube and weave-npc images using [grype](https://github.com/anchore/grype). It saves scan results in the directory `reweave/scans`.

### reweave/tools/clean-scans.sh

This script clears the `reweave/scans` directory.
