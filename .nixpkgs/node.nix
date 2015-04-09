{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv }:

with pkgs;

stdenv.mkDerivation {
  name = "impureNodeEnv";
  buildInputs = [
    nodejs
    stdenv
  ];
}
