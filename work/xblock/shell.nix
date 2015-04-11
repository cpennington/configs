{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv }:

with pkgs;

config.impurePythonEnv
