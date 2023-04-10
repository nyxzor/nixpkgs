{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
      pname = "torrserver";
      version = "121";
      src = fetchurl {
        url = "https://github.com/YouROK/TorrServer/releases/download/MatriX.${version}/TorrServer-linux-amd64";
        sha256 = "0yl2p42i11bvcmzdbygp0xpz92w26bqy4qp01b23bw12d2jxk3j5";
      };
    
    phases = [ "installPhase" "patchPhase" ];

    installPhase =''
    mkdir -p $out/bin
    cp $src $out/bin/torrserver
    chmod +x $out/bin/torrserver
    '';
  meta = with lib; {
    description = "Torrent stream server";
    homepage = "https://github.com/YouROK/TorrServer";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
