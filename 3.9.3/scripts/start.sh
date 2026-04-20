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
  # Clone source code
  cd /tmp
  git clone https://github.com/commercialhaskell/stack.git
  cd stack
  git checkout v3.9.3
  stack -j2 install \
    --no-install-ghc \
    --system-ghc \
    --flag=stack:static \
    --stack-yaml stack-ghc-$GHC_VERSION.yaml

  cp -aL /root/.local/bin/stack "/tmp$PREFIX/bin"
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
