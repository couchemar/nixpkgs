{ lib, stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, pkgconfig, gstreamer, xineLib, glib, python27, python27Packages, unzip
, enableBloat ? false }:

let v = "2.4.10"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/opencv-${v}.zip";
    sha256 = "1ilnfm7id8jqg5xmfjhbq81sjxx64av90kwxcs8zv5rp523wpx0v";
  };

  buildInputs =
    [ unzip libjpeg libpng libtiff ]
    ++ lib.optionals enableBloat [ gtk glib jasper ffmpeg xineLib gstreamer python27 python27Packages.numpy ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric flosse];
    platforms = with stdenv.lib.platforms; linux;
  };
}
