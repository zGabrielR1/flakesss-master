#!/bin/bash

# Function to switch between Hyprland rices
switch_hyprland() {
  rice_name="$1"
  echo "Switching to Hyprland rice: $rice_name"

  # Define the path to the Hyprland flake configuration
  hyprland_flake="/home/zrrg/Documentos/dotfiles-nix/home/profiles/zrrg/wm/hyprland/$rice_name#raagh"

  # Rebuild home-manager configuration
  home-manager build --flake "$hyprland_flake"

  # Apply the new configuration
  home-manager switch --flake "$hyprland_flake"

  # Restart Hyprland
  hyprctl reload
}

# Function to switch between AwesomeWM rices
switch_awesomewm() {
  rice_name="$1"
  echo "Switching to AwesomeWM rice: $rice_name"

  # Define the path to the AwesomeWM flake configuration
  awesomewm_flake="/home/zrrg/Documentos/dotfiles-nix/home/profiles/zrrg/wm/awesome/$rice_name#homeConfigurations.$USER"

  # Rebuild home-manager configuration
  home-manager build --flake "$awesomewm_flake"

  # Apply the new configuration
  home-manager switch --flake "$awesomewm_flake"

  # Restart AwesomeWM
  awesome-client "awesome.restart()"
}

# Main function to parse arguments and call the appropriate function
main() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [hyprland|awesomewm] [rice_name]"
    exit 1
  fi

  wm="$1"
  rice_name="$2"

  case "$wm" in
    hyprland)
      switch_hyprland "$rice_name"
      ;;
    awesomewm)
      switch_awesomewm "$rice_name"
      ;;
    *)
      echo "Invalid window manager: $wm"
      exit 1
      ;;
  esac
}

# Call the main function
main "$@"