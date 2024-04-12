#!/bin/bash

# This script is extracted from docs in riscv-gnu-toolchain repo.

set -e

sudo apt install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev cmake ninja-build pkg-config libglib2.0-dev libpixman-1-dev git libfdt-dev libncurses5-dev libncursesw5-dev device-tree-compiler

PREFIX="/opt/riscv"

git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

cd riscv-gnu-toolchain

./configure --prefix="${PREFIX}"
make newlib -j $(nproc)
make linux -j $(nproc)

export PATH="$PATH:$PREFIX/bin"
export RISCV="$PREFIX"

cd ../
git clone --recursive https://gitlab.com/qemu-project/qemu.git qemu-project
cd qemu-project
mkdir build
cd build
../configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=$RISCV/qemu
ninja

cd ../..
git clone https://github.com/llvm/llvm-project.git
cd llvm-porject
mkdir build
cd build
cmake -DLLVM_TARGETS_TO_BUILD="RISCV" -DLLVM_ENABLE_PROJECTS="clang;llvm" -DCMAKE_BUILD_TYPE=Release  -G "Ninja" ../llvm
ninja