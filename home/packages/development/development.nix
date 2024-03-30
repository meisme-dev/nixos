{ pkgs, ... }:

{
  imports =
    [
      ./c.nix
      ./haskell.nix
      ./neovim/neovim.nix
      ./nixlang.nix
      ./rust.nix
    ];

  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    lua-language-server
    git
    gh
    helix
    jq
    python3
  ];
}
