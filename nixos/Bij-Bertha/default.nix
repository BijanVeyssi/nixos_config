{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../common/global
    ../common/users/bijan

    ../common/optional/docker.nix
    ../common/optional/fish.nix
    ../common/optional/gnupg.nix
    ../common/optional/hyprland.nix
    ../common/optional/input.nix
    ../common/optional/nvidia.nix
    ../common/optional/openssh.nix
    ../common/optional/pipewire.nix
    ../common/optional/printing.nix
    ../common/optional/steam.nix
  ];

  networking = {
    hostName = "Bij-Bertha";
  };

  boot = {
    kernel.sysctl = {
      "kernel.core_pattern" = "/var/crash/core.%t.%p";
      "kernel.panic" = 10;
      "kernel.unknown_nmi_panic" = 1;
    };

    loader = {
      limine = {
        secureBoot.enable = true;
        efiSupport = true;
        enable = true;
      };
    };
  };

  systemd.user.services.nix-gc = {
    description = "Garbage collection for user profiles";
    script = "/run/current-system/sw/bin/nix-collect-garbage --delete-older-than 21d";
    startAt = "daily";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
