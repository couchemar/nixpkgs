{ stdenv, fetchurl, jdk, gtk2, xulrunner, zip, pkgconfig, perl, npapi_sdk, bash }:

stdenv.mkDerivation rec {
  name = "icedtea-web-${version}";

  version = "1.5.2";

  src = fetchurl {
    url = "http://icedtea.wildebeest.org/download/source/${name}.tar.gz";

    sha256 = "1wrvl66qj0yhaqqhcq24005ci5sc3w005809cld55iiwagr8z7mj";
  };

  buildInputs = [ gtk2 xulrunner zip pkgconfig npapi_sdk ];

  preConfigure = ''
    substituteInPlace javac.in --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'

    configureFlags="BIN_BASH=${bash}/bin/bash $configureFlags"
  '';

  configureFlags = [
    "--with-jdk-home=${jdk}"
  ];

  mozillaPlugin = "/lib";

  meta = {
    description = "Java web browser plugin and an implementation of Java Web Start";
    longDescription = ''
      A Free Software web browser plugin running applets written in the Java
      programming language and an implementation of Java Web Start, originally
      based on the NetX project.
    '';
    homepage = http://icedtea.classpath.org/wiki/IcedTea-Web;
    maintainers = with stdenv.lib.maintainers; [ wizeman ];
    platforms = stdenv.lib.platforms.linux;
  };
}
