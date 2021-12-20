{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
	nativeBuildInputs = with pkgs; [ 
    zsh
    any-nix-shell
    neovim
    hugo
    ];
    shellHook = ''
        exec zsh
    '';	
}
