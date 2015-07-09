{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv }:

with pkgs;
with pkgs.python27Packages;

let

mkTox192 = {tox}:
  pkgs.stdenv.lib.overrideDerivation tox (oldAttrs: {
    name = "tox-1.9.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/t/tox/tox-1.9.2.tar.gz";
      md5 = "f4db4d6a82d6a651e457ba55ef370258";
    };
  });

mkPip611 = {pip}:
  pkgs.stdenv.lib.overrideDerivation pip (oldAttrs: {
    name = "pip-6.1.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pip-6.1.1.tar.gz";
      md5 = "6b19e0a934d982a5a4b798e957cb6d45";
    };
  });

mkVirtualenv1211 = {virtualenv}:
  pkgs.stdenv.lib.overrideDerivation virtualenv (oldAttrs: {
    name = "virtualenv-12.1.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/virtualenv-12.1.1.tar.gz";
      md5 = "901ecbf302f5de9fdb31d843290b7217";
    };
  });

mkXmlsecWithOpenssl = {xmlsec}:
  pkgs.stdenv.lib.overrideDerivation xmlsec (oldAttrs: {
    buildInputs = [ libxml2 gnutls libxslt pkgconfig libgcrypt libtool pkgs.openssl ];
    configureOptions = "--with-openssl=${pkgs.openssl}";
    });

in

buildPythonPackage {
  name = "impurePythonEnv";
  buildInputs = [
    blas
    #(mkPip611 {pip=python27Packages.pip;})
    #(mkPip611 {pip=python34Packages.pip;})
    #(mkVirtualenv1211 {virtualenv=python27Packages.virtualenv;})
    #(mkVirtualenv1211 {virtualenv=python34Packages.virtualenv;})
    (mkTox192 {tox=python27Packages.tox;})
    (mkTox192 {tox=python34Packages.tox;})
    chromedriver
    gcc49
    geos
    gfortran
    gnumake41
    graphviz
    liblapack
    libxml2
    libxslt
    libyaml
    libzip
    nodejs # TODO: Remove this and figure out a way to combine build environments
    openssl
    pkgconfig
    python2Full
    python27Packages.pip
    python27Packages.virtualenv
    python3
    python34Packages.pip
    python34Packages.virtualenv
    stdenv
    xmlsec
    zeromq4
    zlib
  ];
  src = null;
  # When used as `nix-shell --pure`
  shellHook = ''
  unset http_proxy
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
  export LIBRARY_PATH="\
$(cat ${stdenv.cc}/nix-support/orig-cc)/lib64:\
${libxml2}/lib:\
${graphviz}/lib:\
${liblapack}/lib:\
${blas}/lib:\
${geos}/lib:\
${openssl}/lib:\
${libyaml}/lib:\
${xmlsec}/lib:\
${zeromq4}/lib:\
${libtool}/lib"
  export LD_LIBRARY_PATH=$LIBRARY_PATH
  export C_INCLUDE_PATH="${xmlsec}/include/xmlsec1"
  export BLAS="${blas}/lib/libblas.so"
  export LAPACK="${liblapack}/lib/liblapack.a"
  '';
  # used when building environments
  extraCmds = ''
  unset http_proxy # otherwise downloads will fail ("nodtd.invalid")
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
  export LIBRARY_PATH="${libxml2}/lib:${graphviz}/lib:${liblapack}/lib:${blas}/lib:${geos}/lib:${openssl}/lib:${libyaml}/lib:${xmlsec}/lib"
  export C_INCLUDE_PATH="${xmlsec}/include/xmlsec1"
  export LD_LIBRARY_PATH=$LIBRARY_PATH
  export BLAS="${blas}/lib/libblas.so"
  export LAPACK="${liblapack}/lib/liblapack.a"
  '';

}
