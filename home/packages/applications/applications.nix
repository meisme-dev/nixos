{ pkgs, ... }:

{
  imports =
    [
      ./games.nix
      ./obs.nix
      ./qutebrowser/qutebrowser.nix
    ];
    
  home.packages = with pkgs; [
    blackbox-terminal
    blanket
    discordo
    firefox
    floorp
    fragments
    gimp
    gnome-extension-manager
    gnome.gnome-tweaks
    gradience
    inkscape
    looking-glass-client
    mangohud
    moonlight-qt
    pavucontrol
    stremio
    sunshine
    thunderbird
  ];
}
