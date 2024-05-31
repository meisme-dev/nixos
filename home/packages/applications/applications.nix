{ pkgs, ... }:

{
  imports =
    [
      ./games.nix
      ./obs.nix
      ./qutebrowser/qutebrowser.nix
    ];
    
  home.packages = with pkgs; [
    anki
    blackbox-terminal
    blanket
    dissent
    firefox
    floorp
    fractal
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
    protonvpn-gui
    stremio
    sunshine
    thunderbird
  ];
}
