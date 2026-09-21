{ config, lib, inputs, ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Map registries to channels
    # Very useful when using legacy commands
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 17d";
    };
    # Detects files with identical content in store and replace them with hard links to a single copy
    settings.auto-optimise-store = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
