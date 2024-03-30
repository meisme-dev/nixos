{ libs, config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
    ];
  };

  # Enable VSCode Marketplace
  home.sessionVariables = {
    VSCODE_GALLERY_SERVICE_URL = "https://marketplace.visualstudio.com/_apis/public/gallery";
    VSCODE_GALLERY_ITEM_URL = "https://marketplace.visualstudio.com/items";
    VSCODE_GALLERY_CACHE_URL = "https://vscode.blob.core.windows.net/gallery/index";
    VSCODE_GALLERY_CONTROL_URL = "";
  };
}
