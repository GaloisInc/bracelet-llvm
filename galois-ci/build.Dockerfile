ARG BUILD_BASE_PARENT
FROM ${BUILD_BASE_PARENT} as build
RUN apt-get update && apt-get install -y \
  git python3 build-essential cmake ninja-build git zlib1g-dev binutils-dev ca-certificates libzstd-dev python3-pip python3-jinja2

COPY . /repo
RUN cd /repo && ./galois-ci/ci.sh

# && \
#   mkdir -p /tmp/mold && \
#   tar -C /tmp/mold -xvf ./galois-ci/mold-2.35.1-x86_64-linux.tar.gz && \
#   cp -r /tmp/mold/*/* /usr/local/ && \
#   mkdir -p /tmp/sccache && \
#   tar -C /tmp/sccache -xvf ./galois-ci/sccache-v0.9.0-x86_64-unknown-linux-musl.tar.xz && \
#   mv /tmp/sccache/*/sccache /usr/local/bin && \
#   python3 galois-ci/build_llvm.py && \
#   cd / && rm -rf /build-ci /repo
#
# We rm -rf intermediate files because REDACTED CI takes a long time to take a snapshot of the full build

ARG BUILD_BASE_PARENT
FROM ${BUILD_BASE_PARENT}
COPY --from=build /opt/galois-llvm-build /opt/galois-llvm-build
# ca-certificates are needed for sccache to talk to artifactory
RUN apt-get update && apt-get install -y ca-certificates libzstd1 zlib1g curl python3 python3-pip ninja-build gdb

