{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Custom VSCode Insiders build
    ((pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        sha256 = "sha256:0s4ijhrjfrz9chbi5mdas7g7lvvcw6r0r25nhzckvffnpc999a64";
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
    jetbrains-toolbox
  ];
}