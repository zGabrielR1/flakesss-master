# modules/nixos/default.nix
# This is the main entry point for shared NixOS system modules.
{ config, pkgs, lib, inputs, ... }:

{
  # Add shared NixOS options and configurations here.
  # For example:
  # environment.systemPackages = [ pkgs.htop ];
  # services.openssh.enable = true;

  # imports = [ ./another-module.nix ];
}