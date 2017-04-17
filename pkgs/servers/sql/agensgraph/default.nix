{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, makeWrapper, perl, bison, flex }:

let

  common = { version, pgVersion, sha256, psqlSchema } @ args:
   let atLeast = lib.versionAtLeast pgVersion; in stdenv.mkDerivation (rec {
    name = "agensgraph-${version}";

    src = fetchurl {
      url = "https://github.com/bitnine-oss/agensgraph/archive/v${version}.tar.gz";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl makeWrapper perl bison flex ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

#    makeFlags = [ "world" ];

    configureFlags = [
      "--with-openssl"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
    ]
      ++ lib.optional (stdenv.isDarwin)  "--with-uuid=e2fs"
      ++ lib.optional (!stdenv.isDarwin) "--with-ossp-uuid";

    patches =
      [ (if atLeast "9.4" then ./disable-resolve_symlinks-94.patch else ./disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./less-is-more-96.patch             else ./less-is-more.patch)
        (if atLeast "9.6" then ./hardcode-pgxs-path-96.patch       else ./hardcode-pgxs-path.patch)
        ./specify_pkglibdir_at_runtime.patch
      ];

#    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postConfigure =
      let path = if atLeast "9.6" then "src/common/config_info.c" else "src/bin/pg_config/pg_config.c"; in
        ''
          # Hardcode the path to pgxs so pg_config returns the path in $out
          substituteInPlace "${path}" --replace HARDCODED_PGXS_PATH $out/lib
        '';

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        # Remove static libraries in case dynamic are available.
        for i in $out/lib/*.a; do
          name="$(basename "$i")"
          if [ -e "$lib/lib/''${name%.a}.so" ] || [ -e "''${i%.a}.so" ]; then
            rm "$i"
          fi
        done
      '';

    postFixup = lib.optionalString (!stdenv.isDarwin)
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema;
    };

    # meta = with lib; {
    #   homepage = http://www.postgresql.org/;
    #   description = "A powerful, open source object-relational database system";
    #   license = licenses.postgresql;
    #   maintainers = [ maintainers.ocharles ];
    #   platforms = platforms.unix;
    #   hydraPlatforms = platforms.linux;
    # };
  });

in {

  agensgraph = common {
    version = "1.1.0";
    pgVersion = "9.6.2";
    psqlSchema = "9.6";
    sha256 = "0qbmzmkl36wv5d66k7s0p0xll4ai1ax3pczrfgxbmfk9i2j1gjzw";
  };

}
