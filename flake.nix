{
  description = "Malaika LCT";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hugo-theme = {
    #  url = "github:kakawait/hugo-tranquilpeak-theme";
    #  flake = false;
    #};
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "malaikalct";
        pkgs = import nixpkgs { inherit system; };
        #themeName = ((builtins.fromTOML
        #  (builtins.readFile "${hugo-theme}/theme.toml")).name);
        #linkThemeScript = ''
        #  mkdir -p themes
        #  ln -snf "${hugo-theme}" themes/${themeName}
        #'';
        buildInputs = [ pkgs.hugo ];
      in {
        packages.${name} = pkgs.stdenv.mkDerivation rec {
          pname = name;
          version = "2022-10-20";
          src = ./.;
          nativeBuildInputs = buildInputs;
          #configurePhase = linkThemeScript;
          buildPhase = ''
            ${pkgs.hugo}/bin/hugo --minify
          '';
          installPhase = ''
            cp -r ./public/ $out
          '';
        };

        defaultPackage = self.packages.${system}.${name};

        devShell = pkgs.mkShell {
          inherit buildInputs system;
          #shellHook = linkThemeScript;
        };
      });
}
