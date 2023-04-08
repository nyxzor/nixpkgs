{ stdenv
, lib
, go
, pkgs
, buildGoModule
, yarn2nix
, mkYarnPackage
, fetchFromGitHub
, fetchurl
, nixosTests
}:

buildGoModule rec {
  pname = "torrserver";
  version = "121";

  src = fetchFromGitHub {
    rev = "MatriX.${version}";
    owner = "YouROK";
    repo = "TorrServer";
    sha256 = "sha256-xFUebXoGSqao7PDGNqk8jfkp64WHlJOBQtp7wsyw5Mc=";
  };

  vendorHash = null;

#  nativeBuildInputs = [ yarn ];

  buildPhase = ''
    go run ./gen_web.go
    cd ./server
    go build -o /dist/TorrServer $src/cmd
  '';

  ldflags = [
    "-s" "-w"
    ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests) torrserver; };

  meta = with lib; {
    description = "Torrent stream server";
    homepage = "https://github.com/YouROK/TorrServer";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ benley fpletz globin willibutz Frostman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
