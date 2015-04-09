{ pkgs ? import <nixpkgs> { inherit system; }, system ? builtins.currentSystem }:

let
    callPackage = pkgs.lib.callPackageWith ( pkgs // pkgs.xlibs // self );

    self = {
        impurePythonEnv = callPackage ./python.nix { };
        impureNodeEnv = callPackage ./node.nix { };
    };
in self