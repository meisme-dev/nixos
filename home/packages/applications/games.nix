{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bottles
    cartridges
    goverlay
    mangohud
  ];
}
