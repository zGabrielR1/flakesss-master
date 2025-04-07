# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = [
    "incusbr0" 
    "docker0" 
];
# Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
        enable = true;
    };
    incus = {
        enable = true;
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.zrrg = {
    isNormalUser = true;
    description = "Gabriel Renostro";
    extraGroups = [ "networkmanager" "wheel" "incus-admin" "podman" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    # packages = with pkgs; [ ]; # System-level packages for user are less common with HM
  };

  # Define Home Manager configuration for the user 'zrrg'
  home-manager.users.zrrg = { pkgs, ... }: {
    imports = [
      # Import your primary home-manager configuration entrypoint
      # Corrected path relative to hosts/laptop/configuration.nix
      ../../modules/home/profiles/zrrg/wm/awesome/aura.nix

      # --- EXAMPLE: Importing an external 'rice' Home Manager module ---
      # Assuming 'kaku' flake input provides a homeManagerModule named 'default'
      # inputs.kaku.homeManagerModules.default

      # --- EXAMPLE: Importing an external 'rice' NixOS module (less common for pure HM rices) ---
      # Some rices might offer NixOS options too, import them here if needed system-wide,
      # or within the HM config if they are HM options.
    ];

    # You can set home-manager options directly here too, or keep them in imported files
    home.username = "zrrg";
    home.homeDirectory = "/home/zrrg";

    # Ensure state version matches system state version for consistency
    home.stateVersion = config.system.stateVersion;
  };
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # GLib and related libraries
    glib
    glib-networking
    gobject-introspection
    
    # NSS components
    nss
    nspr
    
    # System libraries
    dbus
    libdbusmenu-gtk3
    systemd # For libudev.so.1
    
    # GTK and display related
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
    
    # Other dependencies
    libxkbcommon
    expat
    xorg.libxcb
    alsa-lib
    
    # Special handling for libffmpeg.so
    # You may need to copy this from the AppImage itself if it's not in a standard location
    # Otherwise, try using ffmpeg-full which might provide a compatible version
    ffmpeg-full
    
    # Already provided by the system but included for completeness
    # glibc
    # gcc.cc.lib
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    # VSCode Insiders build
    ((pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
      });
      version = "latest";
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    }))
    code-cursor
    windsurf
    git
    runc
    cri-o
    distrobox
    boxbuddy
    toolbox
    pods
    github-desktop
    kitty
    awesome
    niri
    flatpak
    rofi-wayland
    bottles
    wine-staging
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  system.autoUpgrade = {
  enable = true;
  flake = inputs.self.outPath;
  flags = [
    "--update-input"
    "nixpkgs"
    "-L" # print build logs
  ];
  dates = "02:00";
  randomizedDelaySec = "45min";
};
