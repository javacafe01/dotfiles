{ stdenv
, pkgs
, version
, src
}:

stdenv.mkDerivation {
  pname = "roundedSBE";

  inherit version;
  inherit src;

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.extra-cmake-modules
    pkgs.libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    pkgs.libsForQt5.kwindowsystem
    pkgs.libsForQt5.kdecoration
    pkgs.libsForQt5.kinit
    pkgs.libsForQt5.kwin
    pkgs.libepoxy
    pkgs.libsForQt5.kdelibs4support
  ];

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "${pkgs.libsForQt5.kdelibs4support}" "$out"

    substituteInPlace cornersshader/cmake_install.cmake \
      --replace "${pkgs.libsForQt5.kdelibs4support}" "$out"
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];
}          
