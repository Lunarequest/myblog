{
  description = "everything needed to develop my blog";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem( system:
    let 
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.website = pkgs.stdenv.mkDerivation rec {
        pname = "myblog";
        version = "2022-02-20";
        src = {
              path = ./.;
              submodules=true;
        };
        nativeBuildInputs = with pkgs; [ hugo ];
        buildPhase = "
          git submodule init
          git submodule init --merge
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
          test -f ~/.zshrc && exec zsh
        '';
      };
  });
}
