#!/usr/bin/env bash
#===- llvm/utils/docker/scripts/checkout.sh ---------------------===//
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
#===-----------------------------------------------------------------------===//

set -e

# The LLVM_BRANCH can use the branch or tag name.
LLVM_BRANCH="llvmorg-16.0.0"

CLANG_BUILD_DIR=/tmp/clang-build

# Get the sources from git.
echo "Checking out sources from git"
mkdir -p "$CLANG_BUILD_DIR/src"
CHECKOUT_DIR="$CLANG_BUILD_DIR/src"

echo "Checking out https://github.com/llvm/llvm-project.git to $CHECKOUT_DIR"
git clone -b $LLVM_BRANCH \
  "https://github.com/llvm/llvm-project.git" \
  "$CHECKOUT_DIR"

echo "Done"