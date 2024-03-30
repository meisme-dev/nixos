{ libs, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cabal-install
    haskell-language-server
    ghc
  ];
}
