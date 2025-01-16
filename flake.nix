{
  description = "Tabler icons font flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      targetSystems = [ "x86_64-linux" "aarch64-linux" ];
      buildFor = system: import nixpkgs { inherit system; };
    in {
      overlays.default = final: prev: {
        inherit (self.packages.${prev.system}) tabler-icons;
      };
      
      packages = nixpkgs.lib.genAttrs targetSystems (system:
        let
          pkgs = buildFor system;
        in rec {
          tabler-icons = pkgs.callPackage ({ lib, fetchzip, stdenvNoCC }:
            stdenvNoCC.mkDerivation rec {
              pname = "tabler-icons";
              version = "3.28.1";

              src = fetchzip {
                url = "https://github.com/tabler/tabler-icons/releases/download/v${version}/tabler-icons-${version}.zip";
                sha256 = "sha256-RPJAJcXou43aXNeJ8a+sT6fTQHaZpyM6SGZGvGfEmMc=";
                stripRoot = false;
              };

              installPhase = ''
                runHook preInstall

                mkdir -p "$out/share/fonts/"{ttf,woff,woff2}
                cp webfont/fonts/tabler-icons.ttf "$out/share/fonts/ttf/"
                cp webfont/fonts/tabler-icons.woff "$out/share/fonts/woff/"
                cp webfont/fonts/tabler-icons.woff2 "$out/share/fonts/woff2/"

                runHook postInstall
              '';

              meta = with lib; {
                description = "Tabler icons font";
                longDescription = '''';
                homepage = "https://tabler.io/icons";
                license = licenses.mit;
                platforms = platforms.all;
                maintainer = [];
              };
            }) {};

          default = tabler-icons;
        }
      );
    };
}
