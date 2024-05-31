{ pkgs, ... }:

{
  imports =
    [
      ./applications/applications.nix
      ./desktop/desktop.nix
      ./development/development.nix
      ./style/style.nix
      ./terminal/terminal.nix
    ];

  home.packages = with pkgs; [
    adw-gtk3
    font-awesome
    gnome.adwaita-icon-theme
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
