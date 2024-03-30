{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lldb
    clang-tools
    meson
    gcc
  ];
}
