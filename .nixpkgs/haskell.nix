{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv }:

with pkgs;

stdenv.mkDerivation {
  name = "impureHaskellEnv";
  buildInputs = [
    ghc.ghc784
    haskellPackages.cabalInstall
    libzip
    zlib
  ];

  src = null;
  # When used as `nix-shell --pure`
  shellHook = ''
  unset http_proxy
  export LIBRARY_PATH="${libzip}/lib:${zlib}/lib"
  export LD_LIBRARY_PATH=$LIBRARY_PATH
  '';
  # used when building environments
  extraCmds = ''
  unset http_proxy # otherwise downloads will fail ("nodtd.invalid")
  export LIBRARY_PATH="${libzip}/lib:${zlib}/lib"
  export LD_LIBRARY_PATH=$LIBRARY_PATH
  '';

}

