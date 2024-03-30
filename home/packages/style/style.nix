{ pkgs, ... }:

{
  imports =
    [
      ./stylix.nix
    ];

  home.packages = with pkgs; [
    pamixer
    font-awesome
    material-symbols
    material-design-icons
    adw-gtk3
    gnome.adwaita-icon-theme
    unzip
    pomodoro
 ];
}
