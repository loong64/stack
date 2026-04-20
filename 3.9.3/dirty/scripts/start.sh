#!/bin/bash
# Copyright (c) 2026 Olivier Benz.
# Distributed under the terms of the MIT License.

set -e

# Test if PREFIX location is whithin limits
if [[ ! "$PREFIX" == "/usr/local" && ! "$PREFIX" =~ ^"/opt" ]]; then
  echo "ERROR:  PREFIX set to '$PREFIX'. Must either be '/usr/local' or within '/opt'."
  exit 1
fi

# Test if there is a bin folder at PREFIX
if [[ ! -d "/tmp$PREFIX/bin" ]]; then
  echo "ERROR:  There is no 'bin' folder in '$PREFIX'."
  echo "INFO:   Execute 'mkdir -p $PREFIX/bin'" to create one.
  exit 1
fi

if [[ "$MODE" == "install" ]]; then
  cabal update

  # Download and extract source code
  cd /tmp
  curl -sSL https://github.com/commercialhaskell/stack/archive/refs/tags/v"$STACK_VERSION_BUILD".tar.gz \
    -o stack.tar.gz
  tar -xzf stack.tar.gz
  cd stack-*

  # Modify config
  sed -i s/ghc-9.10.3/ghc-9.12.2/g cabal.project
  sed -i /^import/d cabal.project

  # Build and install
  cabal -j2 build \
    --enable-executable-static \
    --ghc-options='-split-sections -optl=-pthread' \
    --constraint='tls == 2.2.2'

  strip "$(find dist-newstyle -name stack -type f)"

  cp -aL "$(find dist-newstyle -name stack -type f)" "/tmp$PREFIX/bin"
  echo "INFO:   Stack v$STACK_VERSION_BUILD installed in '$PREFIX/bin'."
elif [[ "$MODE" == "uninstall" ]]; then
  if [[ -f "/tmp$PREFIX/bin/stack" ]]; then
    rm -f "/tmp$PREFIX/bin/stack"
    echo "INFO:   Stack uninstalled from '$PREFIX/bin'."
  else
    echo "ERROR:  Stack not found in '$PREFIX/bin'!"
    exit 1
  fi
else
  echo "ERROR:  Execution mode '$MODE' not supported!"
  exit 1
fi
