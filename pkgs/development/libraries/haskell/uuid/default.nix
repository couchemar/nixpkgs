# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, cryptohash, deepseq, hashable, HUnit, networkInfo
, QuickCheck, random, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "uuid";
  version = "1.3.5";
  sha256 = "1pbla9fqadk5ia42c45qvdn1617gl8nv3b0bsb5yy3lh414v32q9";
  buildDepends = [
    binary cryptohash deepseq hashable networkInfo random time
  ];
  testDepends = [
    HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/uuid/";
    description = "For creating, comparing, parsing and printing Universally Unique Identifiers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
