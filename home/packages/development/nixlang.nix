{ libs, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil
  ];
}