{ config, pkgs, lib, inputs, ... }:

# This module integrates the Hyprland configuration from isabel-roses-dotfiles.
# It assumes necessary inputs (like catppuccin, etc.) are available in the main flake.

{
  imports = [
    # Import relevant modules from the isabel-roses-dotfiles source directory
    ./isabel-roses-dotfiles/modules/home/packages.nix
    ./isabel-roses-dotfiles/modules/home/programs # This likely contains hyprland, waybar, etc.
    ./isabel-roses-dotfiles/modules/home/desktop.nix
    # ./isabel-roses-dotfiles/modules/home/home.nix # Import cautiously, might override base settings
    # ./isabel-roses-dotfiles/modules/home/environment # Import cautiously, might override base settings
  ];

  # Add any specific overrides or additional configurations for your setup below
  # For example:
  # programs.hyprland.settings = {
  #   monitor = ",preferred,auto,1";
  # };

  # Ensure necessary inputs are passed if modules expect them via specialArgs
  # This might require adjustments in the main flake.nix specialArgs if not already done.

}