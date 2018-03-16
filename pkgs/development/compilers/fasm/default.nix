{ multiStdenv, fetchurl }:

multiStdenv.mkDerivation rec {
  name = "fasm-${version}";
  version = "1.72";

  src = fetchurl {
    url = "https://flatassembler.net/${name}.tgz";
    sha256 = "1a32hsjxj3sdb8bm30wkg71d12hy1cdpa8scfckm22j1pqch1m1i";
  };

  installPhase = ''
  mkdir -p $out/bin
  cp fasm fasm.x64 $out/bin/

  for s in symbols prepsrc listing
  do
      $out/bin/fasm.x64 tools/libc/$s.asm $s.o
      gcc -m32 -pie $s.o -o $out/bin/$s
  done
  '';
}
