{
  description = "My configs (Refactored with flake-parts)";

  inputs = {
    # --- Core ---
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default-linux"; # Match flake-parts expectation if needed, or adjust perSystem systems list

    # --- Theming ---
    nix-colors.url = "github:misterio77/nix-colors";
    matugen.url = "github:InioX/matugen";
    # base16-schemes is implicitly pulled by nix-colors/stylix if needed

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
    ags.url = "github:Aylur/ags/v1"; # Keep specific tag for now
    anyrun.url = "github:fufexan/anyrun/launch-prefix"; # Keep specific fork/branch for now

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
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Keep if needed for specific packages
    # ghostty = { url = "github:ghostty-org/ghostty"; }; # Keep if needed

    # --- Compatibility ---
    flake-compat.url = "github:edolstra/flake-compat"; # Keep if legacy tools need it

    # --- Community Repos ---
    nur.url = "github:nix-community/NUR"; # Keep if NUR packages are used
    # --- Rices ---
    amadeus-wm-nixos-dots.url = "github:AmadeusWM/nixos-dots";
    CmrCrabsNixDots.url = "github:CmrCrabs/nixdots";
    crystal-og.url = "github:namishh/crystal";
    isabel-roses-dotfiles.url = "github:isabelroses/dotfiles";
    kaku.url = "github:linuxmobile/kaku";
    ndots.url = "github:niksingh710/ndots";
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ]; # Define supported systems
      perSystem = { config, pkgs, system, lib, ... }: {
        # Packages defined in pkgs/ can be exposed here if needed
        # Example: packages = import ./pkgs { inherit pkgs; };
        # Or specific packages: packages.my-package = pkgs.callPackage ./pkgs/my-package {};

        # DevShells can be defined here
        # devShells.default = pkgs.mkShell { ... };
      };
      flake = {
        # NixOS Configurations
        nixosConfigurations = {
          "laptop" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux"; # Or reference system from perSystem if multiple are supported
            specialArgs = { inherit inputs self; }; # Pass inputs and self
            modules = [
              # Core Modules
              home-manager.nixosModules.home-manager

              # Custom NixOS Modules (Import the top-level module directly)
              ./modules/nixos/default.nix

              # Host specific config
              ./hosts/laptop/configuration.nix # Assuming this is the main entry point for the host

              # Hyprland Module (if needed system-wide)
              inputs.hyprland.nixosModules.default

              # Global settings previously defined inline
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                nix.settings = {
                  substituters = [
                    "https://cache.nixos.org/"
                    "https://zgabrielr.cachix.org" # Keep user cache
                    "https://hyprland.cachix.org"
                    "https://nix-community.cachix.org"
                    # "https://nixos.org/channels/nixos-unstable" # Usually covered by cache.nixos.org
                    "https://numtide.cachix.org"
                    "https://divnix.cachix.org"
                    "https://nixpkgs-wayland.cachix.org"
                    # Add chaotic cache if chaotic input is used
                    # "https://chaotic.cachix.org/"
                  ];
                  trusted-public-keys = [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    "zgabrielr.cachix.org-1:DNsXs3NCf3sVwby1O2EMD5Ai/uu1Z1uswKSh47A1mvw=" # Keep user cache key
                    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiQMmr7/mho7G4ZPo="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    "numtide.cachix.org-1:53/BlWLgjTTnOEGTBrOsbOWmA5BoTyJkj8eIG3mA0n8="
                    "divnix.cachix.org-1:Ek/jazMWxT9v7i1I95Z6lfxyvMZgF3eLnMWajJ2KKZ0="
                    "nixpkgs-wayland.cachix.org-1:XJ1a29PyPzUz8W6sEhnOTrF3OSa/6MExNdeyDOvGrmM="
                    # Add chaotic key if chaotic input is used
                    # "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12fFjjJUbTBPoGio="
                  ];
                  auto-optimise-store = true;
                  trusted-users = [ "root" "@wheel" ];
                  # Add experimental features if needed, e.g., for flakes and nix-command
                  experimental-features = [ "nix-command" "flakes" ];
                };
              }
            ];
          };
          # Add other hosts here if needed
          # "desktop" = nixpkgs.lib.nixosSystem { ... };
        };

        # Home Manager Configurations (if managing standalone HM users)
        # homeConfigurations = {
        #   "zrrg@laptop" = home-manager.lib.homeManagerConfiguration {
        #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Or use pkgs from perSystem
        #     extraSpecialArgs = { inherit inputs self; };
        #     modules = [
        #       ./home/zrrg/home.nix # Assuming a base home.nix for the user
        #       # Import specific profile modules as needed, potentially driven by specialArgs
        #       # ./home/profiles/zrrg/wm/awesome/aura.nix
        #     ];
        #   };
        # };

        # NixOS and Home Manager modules are now imported directly where needed
        # (NixOS modules in nixosConfigurations, HM modules within host config)

        # Expose a simple package for testing
        packages.x86_64-linux.hello = inputs.nixpkgs.legacyPackages.x86_64-linux.hello;
        packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      };
    };
}
