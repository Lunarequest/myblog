{
  description = "everything needed to develop my blog";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    harbor = {
      url = "github:matsuyoshi30/harbor";
      flake= false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem( system:
    let 
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.website = pkgs.stdenv.mkDerivation rec {
        pname = "myblog";
        version = "2022-02-20";
        src = ./.;
        nativeBuildInputs = with pkgs; [ hugo ];
        buildPhase = "
          mkdir -p themes
          ln -s ${inputs.harbor} themes/harbor
          hugo --gc --minify -b https://nullrequest.com/
        ";
        installPhase = "cp -r public $out";
      };

      defaultPackage = self.packages.${system}.website;

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          hugo
          neovim
        ];
        shellHook = ''
          test -d && rm -rf themes
          mkdir -p themes
          ln -s ${inputs.harbor} themes/harbor
          test -f ~/.zshrc && exec zsh
        '';
      };
  });
}
