{ stdenv, wrapCC, runtimeShell }:
wrapCC (stdenv.mkDerivation {
  name = "impure-clang";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    for bin in clang clang++; do
      cat > $out/bin/$bin <<EOF
#!${runtimeShell}
exec "${toString ./.}/build/bin/$bin" "\$@"
EOF
      chmod +x $out/bin/$bin
    done
  '';
  passthru.isClang = true;
})

