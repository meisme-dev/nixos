{ pkgs, ... }:

{
  stylix.image = ../../assets/bg.jpg;
  stylix.polarity = "dark";
  stylix.autoEnable = false;
#  stylix.opacity.terminal = 0.95;
  stylix.fonts.sizes.applications = 11;

  stylix.fonts.monospace = {
    package = pkgs.fira-code-nerdfont;
    name = "FiraCode Nerd Font Mono";
  };

  stylix.cursor = {
    package = pkgs.graphite-cursors;
    name = "graphite-dark";
    size = 16;
  };

  stylix.base16Scheme = ./scheme.yaml;
}
