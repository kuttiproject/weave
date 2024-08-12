# Kutti Weave

This repository contains a fork of Weave Net, the first product developed by Weaveworks, currently community-maintained at [github.com/rajch/weave](https://github.com/rajch/weave). This fork is intended to be a lightweight CNI add-on for Kubernetes, meant for small clusters and non-production use. Unlike the full Weave Net, it is not intended for use with Docker. 

[![Go Report Card](https://goreportcard.com/badge/github.com/kuttiproject/weave)](https://goreportcard.com/report/github.com/kuttiproject/weave)
[![Docker Pulls](https://img.shields.io/docker/pulls/kuttiproject/weave-kube "Number of times the kutti weave-kube image was pulled from the Docker Hub")](https://hub.docker.com/r/kuttiproject/weave-kube)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/kuttiproject/weave?include_prereleases)](https://github.com/kuttiproject/weave/releases)
[![Unique CVE count in all images](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fkuttiproject%2Fweave%2Fmain%2Fscans%2Fbadge.json&label=CVE%20count "The number of unique CVEs reported by scanning all images")](scans/report.md)

## Using Kutti Weave with Kubernetes

On a freshly installed Kubernetes cluster with no CNI add-on installed, run the following:

```
kubectl apply -f https://github.com/kuttiproject/weave/releases/latest/download/kutti-weave.yaml
```

> [!Note]
> This configuration won’t enable encryption by default. To configure encryption, and other parameters, you will need to download the yaml file and edit it, as per [this article](https://rajch.github.io/weave/kubernetes/kube-addon#manually-editing-the-yaml-file) in the full Weave Net documentation. Or, you could wait a bit. Helm chart coming soon. 


## Building Kutti Weave

For now, the only way to build Kutti Weave is via the provided multi-stage Dockerfile. To build for your local Docker engine, in the project directory, simply run:

```
make
```
