# Build process

`build.Dockerfile` builds our version of LLVM and copies it into the output dockerfile.

# Vendored Dependencies

## sccache

Sccache isn't packaged in ubuntu 22.04, so we need to manually vendor it.

## mold

The version of mold packaged in ubuntu 22.04 is AGPL licensed. Modern versions are MIT licensed, so
we vendor a copy of the mold build. It has a dependency on the libatomic1 package, which we make
sure to install.

