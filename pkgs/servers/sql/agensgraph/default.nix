{ fetchFromGitHub, lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, makeWrapper, perl, bison, flex }:

 
stdenv.mkDerivation rec {
  name = "agensgraph-${version}";
  version = "1.1.0";

  # src = fetchurl {
  #   url = "https://github.com/bitnine-oss/agensgraph/archive/v${version}.tar.gz";
  #   sha256 = "0qbmzmkl36wv5d66k7s0p0xll4ai1ax3pczrfgxbmfk9i2j1gjzw";
  # };

            src = fetchFromGitHub {
              owner = "bitnine-oss";
              repo = "agensgraph";
              rev = "6a717c821beadafb8e821ed4e2c34be6f742aea0";
              sha256 = "079zcscqmgx1jrvrcxb8i947k39dzd44m0cs4llqnwww2hsdlm5r";
            };


  # outputs = [ "out" "lib" ];
  # setOutputFlags = false; # $out retains configureFlags :-/

  buildInputs =
    [ readline zlib perl bison flex ];

  enableParallelBuilding = true;

#  makeFlags = [ "world" ];

  # configureFlags = [
  #   "--with-openssl"
  #   "--sysconfdir=/etc"
  #   "--libdir=$(lib)/lib"
  #   "--with-ossp-uuid"
  # ];

  installTargets = [ "install" ];

  LC_ALL = "C";

    # meta = with lib; {
    #   homepage = http://www.postgresql.org/;
    #   description = "A powerful, open source object-relational database system";
    #   license = licenses.postgresql;
    #   maintainers = [ maintainers.ocharles ];
    #   platforms = platforms.unix;
    #   hydraPlatforms = platforms.linux;
    # };
}
