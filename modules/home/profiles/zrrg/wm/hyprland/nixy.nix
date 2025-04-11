{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixy.homeManagerModules.default
  ];

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  # Use nixy's configuration
  nixy = {
    enable = true;
    # You can override specific nixy settings here
    # For example:
    # hyprland.config = {
    #   # Your custom Hyprland config overrides
    # };
  };

  # Additional packages required by nixy
  home.packages = with pkgs; [
    # Hyprland ecosystem
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    hyprcursor

    # Bars and widgets
    waybar
    rofi-wayland
    wofi

    # Utilities
    grim
    slurp
    wl-clipboard
    cliphist
    sway-contrib.grimshot
    brightnessctl
    pamixer
    playerctl
    networkmanagerapplet
    blueman
    pavucontrol
    gtk3
    gtk4
    qt5.qtwayland
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  # Environment variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # Enable required services
  services = {
    # Enable the Hyprland portal
    xdg-desktop-portal-hyprland.enable = true;
    
    # Enable clipboard manager
    cliphist.enable = true;
    
    # Enable network manager applet
    network-manager-applet.enable = true;
    
    # Enable bluetooth
    blueman-applet.enable = true;
  };

  # GTK and Qt theming
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
} 