{ stdenv
, lib
, go
, pkgs
, buildGoModule
, fetchYarnDeps
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
  web = mkYarnPackage {
    inherit version;
    src = "${src}/web";
    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/web/yarn.lock";
      sha256 = "sha256-uLupd44FZPdlC6DMat/7TS1M422FJPwEYqFClRCOdtw=";
    };
    packageJSON = ./package.json;

    buildPhase = ''
      runHook preBuild
      yarn --offline build
      runHook postbuild
    '';
    doDist = false;
  };

  buildPhase = ''
    cp -vr ${web}/* ${src}/web
    go run gen_web.go
    cd ${src}/server
    go build -o /dist/TorrServer ./cmd
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
