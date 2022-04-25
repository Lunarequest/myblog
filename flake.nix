{
  description = "everything needed to develop my blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    harbor = {
      url = "github:matsuyoshi30/harbor";
      flake= false;
    };
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let 
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      genSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      packages =  genSystems(system: rec{
        website = pkgsFor.${system}.stdenv.mkDerivation rec {
          pname = "myblog";
          version = "2022-02-20";
          src = ./.;
          nativeBuildInputs = with pkgsFor.${system}; [ hugo ];
          buildPhase = "
            mkdir -p themes
            ln -s ${inputs.harbor} themes/harbor
            hugo --gc --minify -b https://nullrequest.com/
          ";
          installPhase = "cp -r public $out";
        }; 
        default = website;
      });

      
      devShells = genSystems (system: {
        default = with pkgsFor.${system};
        mkShell ({
            packages = [ hugo ];
            shellHook = ''
                test -f ~/.zshrc && exec zsh
            '';
        });
      });
    };
}
