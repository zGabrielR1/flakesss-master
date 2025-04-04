{ config, pkgs, ... }:

import ./configuration.nix { inherit config pkgs; }