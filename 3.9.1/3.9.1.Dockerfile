ARG IMAGE=ghcr.io/loong64/ghc/ghc-musl
ARG GHC_VERSION=9.14.1
ARG PREFIX=/usr/local

FROM ${IMAGE}:${GHC_VERSION} AS builder

ARG STACK_VERSION_BUILD=3.9.1
ARG PREFIX
ARG MODE=install

COPY scripts/*.sh /usr/bin/

COPY --from=ghcr.io/loong64/commercialhaskell/ssi:3.9.1-dirty-linux-loong64 /usr/local/bin/stack /usr/local/bin

RUN mkdir -p "/tmp$PREFIX/bin" \
 && stack --version \
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
