{ libs, config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    #davinci-resolve
  ];
}
