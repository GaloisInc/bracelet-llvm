setup_tree:
    mkdir -p /opt/galois-llvm/bin/
    python3 ./galois-ci/build_llvm.py --dump-script /opt/galois-llvm/bin/galois-c++.sh --compiler \
         {{justfile_directory()}}/llvm/build/devcontainer/bin/clang++
    python3 ./galois-ci/build_llvm.py --dump-script /opt/galois-llvm/bin/galois-cc.sh --compiler \
         {{justfile_directory()}}/llvm/build/devcontainer/bin/clang
    mkdir -p /opt/scripts
    cp {{justfile_directory()}}/galois-ci/build_file_table.py /opt/scripts
    mkdir -p /opt/toolchain
    cp {{justfile_directory()}}/galois-ci/cmake/* /opt/toolchain
    cp {{justfile_directory()}}/llvm/build/devcontainer/bin/lld /opt/galois-llvm/bin/ld.lld