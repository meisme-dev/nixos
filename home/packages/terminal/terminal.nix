{ libs, config, pkgs, ... }:

{

  imports =
    [
      ./zsh.nix
    #  ./kitty.nix
    ];

  home.packages = with pkgs; [
    fzf
    ripgrep
    bat
    tealdeer
    btop
    fd
  ];

  home.sessionVariables = {
    EDITOR = "helix";
  };
  
  home.sessionPath = [ "$HOME/.local/bin" ];
}
