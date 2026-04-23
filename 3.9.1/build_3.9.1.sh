#!/bin/bash
# Copyright (c) 2024 Olivier Benz.
# Distributed under the terms of the MIT License.

chmod +x scripts/start.sh

# Install emulator (Docker CE)
if [ "$(uname -m)" != "loongarch64" ]; then
  docker run --privileged --rm tonistiigi/binfmt --install loong64
fi

# Install emulator (Docker Desktop)
#docker run --privileged --rm tonistiigi/binfmt:desktop-master --install loong64

docker build \
  --platform linux/loong64 \
  -t ghcr.io/loong64/commercialhaskell/ssi:3.9.1-linux-loong64 \
  -f 3.9.1.Dockerfile \
  .
