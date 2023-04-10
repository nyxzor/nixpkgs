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


let
  pname = "torrserver";
  version = "121";
  src = fetchFromGitHub {
    rev = "MatriX.${version}";
    owner = "YouROK";
    repo = "TorrServer";
    sha256 = "sha256-xFUebXoGSqao7PDGNqk8jfkp64WHlJOBQtp7wsyw5Mc=";
  };
  web = mkYarnPackage {
    inherit pname version;
    src = "${src}/web";

#    yarnNix = ./yarn.nix;
    yarnLock = ./yarn.lock;
    yarnFlags = [
      "--offline"
    ];
#    packageJSON = ./package.json;
    buildPhase = ''
      OUTPUT_DIR=$out yarn --offline build
    '';
  };
in
buildGoModule {
  inherit pname version;
  vendorHash = null;
  src = "${web}/server";
  buildPhase = ''
#    go run gen_web.go
    go build -o /dist/TorrServer ${src}/cmd
  '';

  ldflags = [
    "-s" "-w"
    ];

  doCheck = false;

#  passthru.tests = { inherit (nixosTests) torrserver; };

  meta = with lib; {
    description = "Torrent stream server";
    homepage = "https://github.com/YouROK/TorrServer";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ benley fpletz globin willibutz Frostman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
