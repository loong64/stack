ARG IMAGE=ghcr.io/loong64/ghc/ghc-musl
ARG GHC_VERSION=9.12.2
ARG PREFIX=/usr/local

FROM ${IMAGE}:${GHC_VERSION}-nostack-linux-loong64 AS builder

ARG STACK_VERSION_BUILD=3.9.3
ARG PREFIX
ARG MODE=install

COPY scripts/*.sh /usr/bin/

RUN mkdir -p "/tmp$PREFIX/bin" \
 && start.sh

FROM scratch

ARG IMAGE_LICENSE="MIT"
ARG IMAGE_SOURCE="https://gitlab.b-data.ch/commercialhaskell/ssi"
ARG IMAGE_VENDOR="Olivier Benz"
ARG IMAGE_AUTHORS="Olivier Benz <olivier.benz@b-data.ch>"

LABEL org.opencontainers.image.licenses="$IMAGE_LICENSE" \
      org.opencontainers.image.source="$IMAGE_SOURCE" \
      org.opencontainers.image.vendor="$IMAGE_VENDOR" \
      org.opencontainers.image.authors="$IMAGE_AUTHORS"

ARG PREFIX

COPY --from=builder "/tmp$PREFIX/bin/stack" "$PREFIX/bin/stack"