{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv }:

with pkgs;
with pkgs.python27Packages;

buildPythonPackage {
  name = "impurePythonEnv";
  buildInputs = [
     blas
     gcc49
     geos
     gfortran
     gnumake41
     graphviz
     liblapack
     libxml2
     libxslt
     libzip
     nodejs # TODO: Remove this and figure out a way to combine build environments
     pkgconfig
     python27Full
     python27Packages.virtualenv
     python27Packages.pip
     stdenv
     zlib
     openssl
     libyaml
  ];
  src = null;
  # When used as `nix-shell --pure`
  shellHook = ''
  unset http_proxy
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
  export LIBRARY_PATH="${libxml2}/lib:${graphviz}/lib:${liblapack}/lib:${blas}/lib:${geos}/lib:${openssl}/lib:${libyaml}/lib"
  export LD_LIBRARY_PATH=$LIBRARY_PATH
  export BLAS="${blas}/lib/libblas.so"
  export LAPACK="${liblapack}/lib/liblapack.a"
  '';
  # used when building environments
  extraCmds = ''
  unset http_proxy # otherwise downloads will fail ("nodtd.invalid")
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
  export LIBRARY_PATH="${libxml2}/lib:${graphviz}/lib:${liblapack}/lib:${blas}/lib:${geos}/lib:${openssl}/lib:${libyaml}/lib"
  export LD_LIBRARY_PATH=$LIBRARY_PATH
  export BLAS="${blas}/lib/libblas.so"
  export LAPACK="${liblapack}/lib/liblapack.a"
  '';
}
