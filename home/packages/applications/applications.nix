{ libs, config, pkgs, ... }:

{
  imports =
    [
      ./games.nix
      ./resolve.nix
      ./obs.nix
    ];
    
  home.packages = with pkgs; [
    blackbox-terminal
    blanket
    dissent
    firefox
    floorp
    fragments
    freetube
    gimp
    gnome-extension-manager
    gnome.gnome-color-manager
    gnome-text-editor
    gnome.gnome-tweaks
    gnome.nautilus
    godot_4
    gradience
    inkscape
    kdePackages.kdenlive
    kdePackages.neochat
    looking-glass-client
    mangohud
    moonlight-qt
    pavucontrol
    stremio
    sunshine
    thunderbird
    wvkbd
  ];
}
