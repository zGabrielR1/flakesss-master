{ config, pkgs, lib, ... }:

{
  # Core packages
  home.packages = with pkgs; [
    # Core awesome package
    awesome

    # Shell & Utils
    zsh
    oh-my-zsh
    zsh-powerlevel10k
    pamixer
    imagemagick
    neofetch
    brightnessctl
    inotify-tools
    procps
    brillo
    networkmanager
    bluez
    picom
    redshift
    playerctl
    feh
    i3lock-color
    wl-clipboard
    sway-contrib.grimshot
    slurp

    # Music related
    ncmpcpp
    mpd
    mpdris2

    # Terminal
    wezterm

    # Theming/Appearance
    papirus-icon-theme
    adwaita-qt
    qt5ct
    lxappearance

    # Required for lua pam module
    lua53Packages.lua-pam
  ];

  # Create the lock script
  home.file.".local/bin/lock" = {
    text = ''
      #!/bin/sh
      ${pkgs.playerctl}/bin/playerctl pause
      sleep 0.2
      ${pkgs.awesome}/bin/awesome-client "awesome.emit_signal('toggle::lock')"
    '';
    executable = true;
  };

  # GTK settings
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt settings
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # MPD service
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };

  # Environment variables
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
    EDITOR = "nano";
    VISUAL = "nano";
    BROWSER = "firefox";
    TERMINAL = "wezterm";
    QT_QPA_PLATFORMTHEME = "gtk2";
    QT_STYLE_OVERRIDE = "gtk2";
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "systemd"
        "docker"
        "podman"
      ];
      theme = "powerlevel10k/powerlevel10k";
    };
    initExtra = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Load Powerlevel10k
      source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  # Wezterm configuration
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        font_size = 12.0,
        color_scheme = "Adwaita (dark)",
        window_background_opacity = 0.95,
        enable_tab_bar = true,
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        tab_bar_at_bottom = true,
      }
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Gabriel Renostro";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nano";
    };
  };

  # Enable services
  services = {
    # Enable redshift for eye protection
    redshift = {
      enable = true;
      latitude = "-23.5505";
      longitude = "-46.6333";
      temperature = {
        day = 5500;
        night = 3700;
      };
    };

    # Enable picom for compositing
    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      settings = {
        blur = {
          method = "gaussian";
          size = 10;
          deviation = 5.0;
        };
        corner-radius = 10;
        rounded-corners-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
        ];
      };
    };
  };
}