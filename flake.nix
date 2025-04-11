{
  description = "Home Manager only configuration for user zrrg";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Add any other inputs required by your home-manager modules here
  };

  outputs = { self, nixpkgs, home-manager, nix-index-db, ... }:
    let
      system = "x86_64-linux";
      username = "zrrg";
      homeDirectory = "/home/zrrg";
    in {
      homeConfigurations = {
        "${username}@laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit self nix-index-db; };
          modules = [
            ./modules/home/profiles/zrrg/default.nix
          ];
        };
      };
    };
}
