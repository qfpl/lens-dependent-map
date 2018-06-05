{ mkDerivation, base, dependent-map, lens, stdenv }:
mkDerivation {
  pname = "lens-dependent-map";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base dependent-map lens ];
  description = "Additional lens functions for Dependent Map structures";
  license = stdenv.lib.licenses.bsd3;
}
