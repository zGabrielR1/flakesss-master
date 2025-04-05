{
  description = "My configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    matugen.url = "github:InioX/matugen";


    # rest of inputs, alphabetical order
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };

    anyrun.url = "github:fufexan/anyrun/launch-prefix";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";

    ags.url = "github:Aylur/ags/v1";
    # ags.url = "github:Aylur/ags";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    mcmojave-hyprcursor.url = "github:libadoxon/mcmojave-hyprcursor";

    lanzaboote.url = "github:nix-community/lanzaboote";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations."laptop" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            nix.settings = {
              substituters = [
                "https://cache.nixos.org/"
                "https://zgabrielr.cachix.org"
                "https://hyprland.cachix.org"
                "https://nix-community.cachix.org"
                "https://nixos.org/channels/nixos-unstable"
                "https://numtide.cachix.org"
                "https://divnix.cachix.org"
                "https://nixpkgs-wayland.cachix.org"
              ];
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "zgabrielr.cachix.org-1:DNsXs3NCf3sVwby1O2EMD5Ai/uu1Z1uswKSh47A1mvw="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiQMmr7/mho7G4ZPo="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "numtide.cachix.org-1:53/BlWLgjTTnOEGTBrOsbOWmA5BoTyJkj8eIG3mA0n8="
                "divnix.cachix.org-1:Ek/jazMWxT9v7i1I95Z6lfxyvMZgF3eLnMWajJ2KKZ0="
                "nixpkgs-wayland.cachix.org-1:XJ1a29PyPzUz8W6sEhnOTrF3OSa/6MExNdeyDOvGrmM="
              ];
              auto-optimise-store = true;
              trusted-users = [ "root" "@wheel" ];
            };
          }
        ];
      };
      homeConfigurations = {
        zrrg = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            # Select ONE of the following window manager configurations:
            # ./home/profiles/zrrg/wm/hyprland/isabel.nix # Hyprland Config (isabel-roses)
            # ./home/profiles/zrrg/wm/hyprland/amadeus.nix # Hyprland Config (amadeus-wm-nixos-dots)
            ./home/profiles/zrrg/wm/awesome/aura.nix # AwesomeWM (Crystal-Aura) Config
            # ./home/profiles/zrrg/wm/niri/kaku.nix    # Niri Config (kaku)
    
            # Other common home-manager modules can be added here, e.g.:
            # ./home/zrrg # If you have a base zrrg home.nix
          ];
        };
      };

      packages.x86_64-linux.hello = pkgs.hello;

      packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
    };
}
