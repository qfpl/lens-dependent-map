{ nixpkgs ? import <nixpkgs> {}
, compiler ? "ghc"
} :
let
  inherit (nixpkgs) pkgs;

  drv = pkgs.haskellPackages.callPackage ./lens-dependent-map.nix {};

in
  if pkgs.lib.inNixShell then drv.env else drv
