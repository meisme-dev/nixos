{
  description = "nixos";
 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:meisme-dev/stylix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { nixpkgs, home-manager, stylix, nixvim, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixconfig = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.users.meisme = {
                imports = [
                  stylix.homeManagerModules.stylix
                  nixvim.homeManagerModules.nixvim
                  ./home/home.nix
                ];
              };
            }
          ];
        };
        iso = lib.nixosSystem {
          inherit system;
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ];
        };
      };
    };
}
