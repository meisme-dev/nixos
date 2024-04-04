{ pkgs, ... }:

{
  imports =
    [
      ./applications/applications.nix
      ./development/development.nix
      ./terminal/terminal.nix
      ./style/style.nix
    ];

  home.packages = with pkgs; [
    adw-gtk3
    font-awesome
    gnome.adwaita-icon-theme
    hikari
    imagemagick
    material-design-icons
    material-symbols
    monkeysphere
    pamixer
    pomodoro
    unzip
    wl-clipboard
 ];
}
