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
    ../common/optional/openssh.nix
    ../common/optional/pipewire.nix
    ../common/optional/printing.nix
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

    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      gfxmodeEfi = "1920x1080";
      # This firmware has no NVRAM entry for the disk, so install to the
      # removable fallback path (\EFI\BOOT\BOOTX64.EFI) to be auto-detected.
      # Mutually exclusive with boot.loader.efi.canTouchEfiVariables.
      efiInstallAsRemovable = true;
    };
  };

  # Passwordless network configuration for the Munic netns tooling. Note that
  # `ip netns exec` runs arbitrary commands as root, so this is close to full
  # root and is deliberately not granted to the whole wheel group.
  security.sudo.extraRules = [{
    users = [ "bijan" ];
    commands = [
      {
        command = "/run/current-system/sw/bin/iptables";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/nft";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/ip";
        options = [ "NOPASSWD" ];
      }
    ];
  }];

  # mdmd itself is a per-user service and lives in
  # home-manager/bijan/munic-notebook.nix.
  systemd.user.services.nix-gc = {
    description = "Garbage collection for user profiles";
    script = "/run/current-system/sw/bin/nix-collect-garbage --delete-older-than 7d";
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
