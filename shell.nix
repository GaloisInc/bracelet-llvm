with import (import ./nix/sources.nix).nixpkgs {};
let llvm = (callPackage ./impure-clang.nix {});
in pkgs.mkShell {
   nativeBuildInputs = [
    cmake ccache mold-wrapped souffle swig ninja graphviz nix perl gdb git
    (writeShellScriptBin "galois-clang" ''
     exec ${llvm}/bin/clang "$@"
    '')
    (writeShellScriptBin "galois-clang++" ''
     exec ${llvm}/bin/clang++ "$@"
    '')
   ];
   buildInputs = [
     zstd
     zlib
     libedit
     libxml2
     (python313.withPackages (py: [py.tqdm py.ipython py.networkx]))
   ];
   CCACHE_DIR = "${toString ./.}/build-ccache";
   GALOIS_CLANG_OVERRIDE = "${llvm}/bin/clang";
   GALOIS_CLANGXX_OVERRIDE = "${llvm}/bin/clang++";
 }
