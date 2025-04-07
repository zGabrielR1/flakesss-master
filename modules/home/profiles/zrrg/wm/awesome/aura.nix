{ config, pkgs, lib, ... }:

{
  # Packages required by crystal-aura theme based on its README and features
  home.packages = with pkgs; [
    # Core awesome package
    awesome

    # Shell & Utils
    zsh
    pamixer
    imagemagick
    neofetch
    brightnessctl
    inotify-tools # Provides inotifywait
    procps        # Provides uptime
    brillo
    networkmanager # For potential applet interaction
    bluez         # Provides bluetoothctl
    picom
    redshift
    playerctl     # For lock script and media controls
    feh           # Simple image viewer and wallpaper setter
    i3lock-color  # Lockscreen mentioned in features
    wl-clipboard  # Clipboard utility
    sway-contrib.grimshot # Screenshot utility often used with slurp
    slurp         # For selecting screen regions

    # Music related
    ncmpcpp
    mpd
    mpdris2

    # Terminal
    wezterm

    # Theming/Appearance related (can be adjusted based on your preferences)
    papirus-icon-theme
    # Add GTK theme if desired, e.g., adapta-gtk-theme or similar
    # Add fonts if needed

    # Required for lua pam module if used by the theme (check if liblua_pam.so is needed)
    lua53Packages.lua-pam # Adjust Lua version if necessary
  ];

  # Copy the crystal-aura configuration files to ~/.config/awesome
  # Using xdg.configFile ensures it goes to the right place (~/.config)
  # xdg.configFile."awesome" = {
  #   source = ./crystal-aura; # Assumes aura.nix is in the parent dir of crystal-aura
  #   recursive = true;
  # };

  # Create the lock script mentioned in the README
  home.file.".local/bin/lock" = {
    text = ''
      #!/bin/sh
      ${pkgs.playerctl}/bin/playerctl pause
      sleep 0.2
      ${pkgs.awesome}/bin/awesome-client "awesome.emit_signal('toggle::lock')"
    '';
    executable = true;
  };

  # Basic GTK settings (optional, adjust as needed)
  gtk = {
    enable = true;
    iconTheme.name = "Papirus";
    # theme.name = "Your-Chosen-GTK-Theme"; # Set your preferred GTK theme
    # font.name = "Your-Chosen-Font";      # Set your preferred font
  };

  # Enable MPD service for the user
  services.mpd = {
    enable = true;
    # Optional: configure music directory, etc.
    musicDirectory = "${config.home.homeDirectory}/Music";
    # databaseFile = "${config.home.homeDirectory}/.config/mpd/database";
    # playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
    # stateFile = "${config.home.homeDirectory}/.config/mpd/state";
    # stickerFile = "${config.home.homeDirectory}/.config/mpd/sticker.sql";
  };

  # Ensure ~/.local/bin is in PATH
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };

}