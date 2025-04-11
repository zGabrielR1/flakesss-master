# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable kernel modules for better hardware support
    kernelModules = [ "kvm-intel" "tcp_bbr" ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      trustedInterfaces = [ "incusbr0" "docker0" ];
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Sao_Paulo";

  # X11 and Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    xkb = {
      layout = "br";
      variant = "nodeadkeys";
    };
  };

  # Console configuration
  console.keyMap = "br-abnt2";

  # Printing
  services.printing.enable = true;

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.zrrg = {
    isNormalUser = true;
    description = "Gabriel Renostro";
    extraGroups = [ "networkmanager" "wheel" "incus-admin" "podman" ];
    shell = pkgs.zsh;
  };

  # Home Manager configuration
  home-manager.users.zrrg = { pkgs, ... }: {
    imports = [
      ../../modules/home/profiles/zrrg/wm/awesome/aura.nix
    ];
    home.username = "zrrg";
    home.homeDirectory = "/home/zrrg";
    home.stateVersion = config.system.stateVersion;
  };

  # Programs
  programs = {
    firefox.enable = true;
    hyprland.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      glib
      glib-networking
      gobject-introspection
      nss
      nspr
      dbus
      libdbusmenu-gtk3
      systemd
      gtk3
      atk
      at-spi2-atk
      at-spi2-core
      cups
      libdrm
      pango
      cairo
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      mesa
      libgbm
      libxkbcommon
      expat
      xorg.libxcb
      alsa-lib
      ffmpeg-full
    ];
    appimage = {
      enable = true;
      binfmt = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Development
    git
    github-desktop
    jetbrains-toolbox
    vscode-with-extensions.override {
      vscode = vscode;
      vscodeExtensions = with vscode-extensions; [
        ms-vscode.cpptools
        ms-python.python
        ms-vscode.cmake-tools
      ];
    }

    # Containers
    runc
    cri-o
    distrobox
    boxbuddy
    toolbox
    pods
    flatpak
    bottles

    # Desktop
    kitty
    awesome
    niri
    rofi-wayland
    wine-staging

    # Utilities
    wget
    curl
    htop
    neofetch
    tree
    file
    unzip
    p7zip
  ];

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "zrrg" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # System settings
  system = {
    stateVersion = "24.11";
    autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };

  # Security
  security = {
    sudo.enable = true;
    sudo.wheelNeedsPassword = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      swaylock = {};
    };
  };

  # Services
  services = {
    # Enable fstrim for SSD optimization
    fstrim.enable = true;
    
    # Enable power management
    power-profiles-daemon.enable = true;
    tlp.enable = true;
    
    # Enable bluetooth
    blueman.enable = true;
    
    # Enable printing
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };
}