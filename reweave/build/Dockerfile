# syntax=docker/dockerfile:1
ARG ALPINE_BASEIMAGE

########
# Stage 1: Builderbase
# This stage will build all Weave Net executables.
FROM golang:1.22.6-alpine3.20 AS builderbase
ARG BUILDARCH
ARG TARGETARCH
ARG WEAVE_VERSION
ENV ARCH=${TARGETARCH}
ENV BUILDARCH=${BUILDARCH}
ENV WEAVE_VERSION=${WEAVE_VERSION}

WORKDIR /root/weave
COPY go.* .

RUN go mod download -x
RUN apk update && \
    apk add build-base libpcap-dev
# RUN <<EOMAKE
# cd reweave/build 
# CGO_ENABLED=1 make all
# EOMAKE
# End Stage 1
########

FROM builderbase AS builder
ARG BUILDARCH
ARG TARGETARCH
ARG WEAVE_VERSION
ENV ARCH=${TARGETARCH}
ENV BUILDARCH=${BUILDARCH}
ENV WEAVE_VERSION=${WEAVE_VERSION}

COPY . .

RUN <<EOMAKE
cd reweave/build 
CGO_ENABLED=1 make all
EOMAKE


########
# Stage 2: Alpine Base
# This stage adds packages common to both add-on
# and network policy controller, and allows for
# any further tweaks required on top of the base
# image.
FROM ${ALPINE_BASEIMAGE} as alpinebase
RUN <<EOBASE
apk update && apk upgrade
apk add iptables ipset 
# Alpine 3.19 made nftables the default backend 
# for iptables. For backward compatibility, the
# following is required:
apk add iptables-legacy
ln -sf /sbin/iptables-legacy /sbin/iptables
ln -sf /sbin/iptables-legacy-save /sbin/iptables-save
ln -sf /sbin/iptables-legacy-restore /sbin/iptables-restore
EOBASE
# Any additional tweaks will appear here
# End Stage 2
########

########
# Stage 3: weavekube image
# This will be tagged as REGISTRY_USER/weave-kube:VERSION
FROM alpinebase AS weavekubeimage
LABEL maintainer="Kutti Project <support@kuttiproject.org>"

RUN <<EOWEAVER
      apk add --update \
                  curl \
                  iproute2 \
                  conntrack-tools \
                  bind-tools \
                  ca-certificates
      rm -rf /var/cache/apk/*
EOWEAVER

WORKDIR /home/weave
COPY --from=builder /root/weave/weave \
                    /root/weave/prog/weaver/weaver \
                    /root/weave/prog/weave-kube/init.sh \
                    /root/weave/prog/weave-kube/launch.sh \
                    /root/weave/prog/kube-utils/kube-utils \
                    /home/weave/
COPY --from=builder /root/weave/prog/weaveutil/weaveutil /usr/bin/
COPY --from=builder /root/weave/prog/weaver/weavedata.db /weavedb/

ENTRYPOINT ["/home/weave/launch.sh"]
# End Stage 3
########

########
# Stage 4: weavenpc image
# This will be tagged as REGISTRY_USER/weave-npc:VERSION
FROM alpinebase AS weavenpcimage
LABEL maintainer="Kutti Project <support@kuttiproject.org>"

RUN <<EONPC
      apk add --update \
                  ulogd
      mknod /var/log/ulogd.pcap p      
      rm -rf /var/cache/apk/*
EONPC
COPY --from=builder /root/weave/prog/weave-npc/weave-npc /usr/bin/weave-npc
COPY --from=builder /root/weave/prog/weave-npc/ulogd.conf /etc/ulogd.conf
COPY --from=builder /root/weave/prog/weave-npc/launch.sh /usr/bin/
ENTRYPOINT ["/usr/bin/launch.sh"]
# End Stage 4
########
