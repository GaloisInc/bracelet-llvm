#!/usr/bin/env bash
set -euxo pipefail

PREFIX="/opt/galois-llvm-build"
LLVM_BUILD_DIR="/llvm-build"

tar -C /usr/local --strip-components 1 -xvf ./galois-ci/mold-2.35.1-x86_64-linux.tar.gz
mkdir -p /tmp/sccache
tar -C /tmp/sccache -xvf ./galois-ci/sccache-v0.9.0-x86_64-unknown-linux-musl.tar.xz
mkdir -p $PREFIX/bin
mv /tmp/sccache/*/sccache "$PREFIX/bin"

export SCCACHE_IDLE_TIMEOUT=0
source galois-ci/sccache.env
mkdir -p $PREFIX/share
cp galois-ci/sccache.env $PREFIX/share/sccache.env

cmake -S llvm -B "$LLVM_BUILD_DIR" -G Ninja \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  "-DLLVM_ENABLE_PROJECTS=clang;lld;lldb" \
  -DLLVM_USE_LINKER=mold \
  -DLLVM_APPEND_VC_REV=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DCLANG_VENDOR=galois \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DBUILD_SHARED_LIBS=ON \
  -DLLVM_ENABLE_PIC=ON \
  -DLLVM_ENABLE_RUNTIMES=compiler-rt \
  -DLLVM_BINUTILS_INCDIR=/usr/include \
  -DLLDB_ENABLE_CURSES=0 \
  -DLLVM_FORCE_VC_REPOSITORY=https://gitlab-ext.galois.com/bracelet/llvm-project \
  -DCMAKE_C_COMPILER_LAUNCHER=$PREFIX/bin/sccache \
  -DCMAKE_CXX_COMPILER_LAUNCHER=$PREFIX/bin/sccache \


ninja -C $LLVM_BUILD_DIR install

$PREFIX/bin/sccache --show-stats

# We rm -rf intermediate files because REDACTED CI takes a long time to take a snapshot of the full build
cd /
rm -rf $LLVM_BUILD_DIR /repo

