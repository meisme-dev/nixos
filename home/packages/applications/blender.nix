{ libs, config, pkgs, ... }:
{
  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [
      (final: prev: {
        blender = prev.blender.override { cudaSupport = true; };
      })
    ];
  };

  home.packages = with pkgs; [
    blender
  ];
}
