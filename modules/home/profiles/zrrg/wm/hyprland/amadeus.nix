{ config, pkgs, lib, ... }:

{
  imports = [
    # Core Hyprland config
    ./amadeus-wm-nixos-dots/graphical/hyprland/default.nix

    # Optional: keybinds and monitor configs
    ./amadeus-wm-nixos-dots/graphical/hyprland/config/keybinds.nix
    ./amadeus-wm-nixos-dots/graphical/hyprland/config/monitors.nix

    # Themes (choose one or import all and switch dynamically)
    # ./amadeus-wm-nixos-dots/graphical/hyprland/themes/comic
    # ./amadeus-wm-nixos-dots/graphical/hyprland/themes/poeisis
    # ./amadeus-wm-nixos-dots/graphical/hyprland/themes/minimalism

    # Services
    ./amadeus-wm-nixos-dots/services/dunst
    ./amadeus-wm-nixos-dots/services/gtklock
    ./amadeus-wm-nixos-dots/services/swayidle

    # Terminal configs
    ./amadeus-wm-nixos-dots/terminal/helix
    ./amadeus-wm-nixos-dots/terminal/starship
    ./amadeus-wm-nixos-dots/terminal/zsh
    ./amadeus-wm-nixos-dots/terminal/broot
    ./amadeus-wm-nixos-dots/terminal/tmux
    ./amadeus-wm-nixos-dots/terminal/zellij

    # Common settings
    ./amadeus-wm-nixos-dots/common.nix
  ];

  # You can override or extend settings here if needed
}