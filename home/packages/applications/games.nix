{ libs, config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      prismlauncher-wayland = prev.prismlauncher.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          pkgs.glfw-wayland-minecraft
        ];
      });
    })
  ];

  home.packages = with pkgs; [
    prismlauncher-wayland
    goverlay
    mangohud
    bottles
    cartridges
    antimicrox
    rpcs3
  ];
}
