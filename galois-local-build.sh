#!/usr/bin/env bash
set -euxo pipefail
if command -v mold >/dev/null 2>/dev/null; then
    LINKER=mold
else
    LINKER=lld
fi
BUILD_TYPE="${1:-Debug}"
BUILD_DIR="build/$BUILD_TYPE"
mkdir -p "$BUILD_DIR"
if [[ $(uname) == "Darwin" ]]; then
    export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
fi
cmake -S llvm -B $BUILD_DIR -G Ninja \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_INSTALL_PREFIX=$PWD/build/prefix \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE '-DLLVM_ENABLE_PROJECTS=clang;lld;lldb' \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DLLVM_USE_LINKER=$LINKER -DBUILD_SHARED_LIBS=ON -DLLVM_APPEND_VC_REV=OFF \
  -DLLVM_OPTIMIZED_TABLEGEN=ON -DLLVM_USE_SPLIT_DWARF=ON \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DLLDB_ENABLE_PYTHON=ON -DLLVM_ENABLE_ASSERTIONS=ON -DLLDB_ENABLE_CURSES=0 \
  -DLLDB_INCLUDE_TESTS=OFF


