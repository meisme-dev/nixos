{ libs, config, pkgs, ... }:

{
  imports =
    [
      ./packages/packages.nix
    ];

  home.username = "meisme";
  home.homeDirectory = "/home/meisme";

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
