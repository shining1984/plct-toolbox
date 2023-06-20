#!/usr/bin/env bash
#===- llvm/utils/docker/scripts/build_install_llvm.sh ---------------------===//
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
#===-----------------------------------------------------------------------===//

set -e

function show_usage() {
  cat << EOF
Usage: build_install_llvm.sh [options] -- [cmake-args]

Run cmake with the specified arguments. Used inside docker container.
Passes additional -DCMAKE_INSTALL_PREFIX and puts the build results into
the directory specified by --to option.

Available options:
  -h|--help           show this help message
  -i|--install-target name of a cmake install target to build and include in
                      the resulting archive. Can be specified multiple times.
Required options: --to, at least one --install-target.

All options after '--' are passed to CMake invocation.
EOF
}

CMAKE_ARGS="-DLLVM_ENABLE_PROJECTS=clang -DLLVM_TARGETS_TO_BUILD=Native -DCMAKE_BUILD_TYPE=Release \ 
    -DBOOTSTRAP_CMAKE_BUILD_TYPE=Release \ 
    -DCLANG_ENABLE_BOOTSTRAP=ON \ 
    -DCLANG_BOOTSTRAP_TARGETS="install-clang;install-clang-resource-headers""
    
CMAKE_INSTALL_TARGETS="stage2-install-clang \
                       stage2-install-clang-resource-headers "

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--install-target)
      shift
      CMAKE_INSTALL_TARGETS="$CMAKE_INSTALL_TARGETS $1"
      shift
      ;;
    --)
      shift
      CMAKE_ARGS="$*"
      shift $#
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
  esac
done

if [ "$CMAKE_INSTALL_TARGETS" == "" ]; then
  echo "No install targets. Please pass one or more --install-target."
  exit 1
fi

CLANG_BUILD_DIR=/tmp/clang-build

mkdir -p "$CLANG_BUILD_DIR/build"
pushd "$CLANG_BUILD_DIR/build"

# Run the build as specified in the build arguments.
echo "Running build"
cmake -GNinja \
  $CMAKE_ARGS \
  "$CLANG_BUILD_DIR/src/llvm"
ninja $CMAKE_INSTALL_TARGETS

popd

# Cleanup.
rm -rf "$CLANG_BUILD_DIR/build"

echo "Done"
