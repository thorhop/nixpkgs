{ stdenv, python27Packages, makeDesktopItem, fetchurl, mesa, which, curl, xterm
  imagemagick, cabextract, icoutils }:
let
  py = python27Packages;
  version = "4.2.5";
in
stdenv.mkDerivation rec {
  name = "playonlinux-${version}";

  src = fetchurl {
    url = "https://www.playonlinux.com/script_files/PlayOnLinux/${version}/PlayOnLinux_${version}.tar.gz";
    sha256 = "15xhninn2lbwsalvlbvnmi9a053q2ivzw6yfp2qjflvalmd3x8cz";
  };

  desktopItem = makeDesktopItem {
    name = "PlayOnLinux";
    exec = "playonlinux";
    icon = "playonlinux";
    comment = "PlayOnLinux";
    desktopName = "PlayOnLinux";
    genericName = "A videogame and emulation manager";
    categories = "Games;";
  };

  python_deps = with py; [ wxPython30 ];

  pythonPath = python_deps;

  propagatedBuildInputs = python_deps;

  buildInputs = [ py.wrapPython mesa which curl xterm imagemagick cabextract icoutils ];

  patchPhase = ''
    patchShebangs
  '';

  configurePhase = "";
  buildPhase = "";

  installPhase = ''
    # Install executable.
    mkdir -p $out/bin
    cp Cura/cura.py $out/bin/cura
    chmod +x $out/bin/cura
    sed -i 's|#!/usr/bin/python|#!/usr/bin/env python|' $out/bin/cura
    wrapPythonPrograms

    # Install desktop item.
    mkdir -p "$out"/share/applications
    cp "$desktopItem"/share/applications/* "$out"/share/applications/
    mkdir -p "$out"/share/icons
    ln -s "$resources/images/c.png" "$out"/share/icons/cura.png
  '';

  meta = with stdenv.lib; {
    description = "A videogame and emulation manager";
    homepage = https://www.playonlinux.com/;
    license = licenses.agpl3;
    platforms = platforms.linux;
  };
}
