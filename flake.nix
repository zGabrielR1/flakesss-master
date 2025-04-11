{
  description = "My NixOS configuration with flake-parts";

  inputs = {
    # --- Core ---
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default-linux";

    # --- Theming ---
    nix-colors.url = "github:misterio77/nix-colors";
    matugen.url = "github:InioX/matugen";

    # --- Hyprland Ecosystem ---
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    mcmojave-hyprcursor.url = "github:libadoxon/mcmojave-hyprcursor";

    # --- Niri ---
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Bars / Launchers / Widgets ---
    ags.url = "github:Aylur/ags/v1";
    anyrun.url = "github:fufexan/anyrun/launch-prefix";

    # --- Utilities / Libraries ---
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };
    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    zen-browser = {
      url = "github:pfaj/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Community Repos ---
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, determinate, chaotic, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      
      perSystem = { config, pkgs, system, lib, ... }: {
        # Define development shells
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixpkgs-fmt
            statix
            deadnix
            alejandra
          ];
        };

        # Define packages
        packages = {
          # Add any custom packages here
          default = self.packages.${system}.hello;
        };
      };

      flake = {
        # NixOS Configurations
        nixosConfigurations = {
          "laptop" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
              home-manager.nixosModules.home-manager
              determinate.nixosModules.default
              chaotic.nixosModules.default
              ./modules/nixos/default.nix
              ./modules/nixos/nix-settings.nix
              ./hosts/laptop/configuration.nix
              inputs.hyprland.nixosModules.default
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; };
              }
            ];
          };
        };

        # Home Manager Configurations
        homeConfigurations = {
          "zrrg@laptop" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs self; };
            modules = [
              ./modules/home/profiles/zrrg/wm/awesome/aura.nix
            ];
          };
        };
      };
    };
}
