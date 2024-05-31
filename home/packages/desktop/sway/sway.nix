{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      input."type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
      };
      window.titlebar = false;
      workspaceAutoBackAndForth = true;
    };
  };

  home.packages = with pkgs; [
    sway-contrib.grimshot
  ];

  programs.foot.enable = true;
}
