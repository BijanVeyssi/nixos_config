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
    hostName = "munic-notebook";

    extraHosts = ''
      10.42.42.208 	releases.system.mdi
      10.42.42.208 	docs.system.mdi
      10.42.42.208 	packages.system.mdi
    '';
  };

  # This panel's HDMI link drops every ~8s under aquamarine's atomic
  # modesetting while staying stable under legacy KMS on the same cable. Legacy
  # KMS has no hotspot-aware cursor ioctl, so pair it with software cursors or
  # the text cursor selects ~11px away from where it points.
  environment.sessionVariables.AQ_DRM_NO_ATOMIC = "1";

  # regreet runs under cage, which is wlroots rather than aquamarine, so it
  # needs the wlroots spelling of the flag above or the greeter flaps too.
  systemd.services.greetd.environment.WLR_DRM_NO_ATOMIC = "1";

  boot = {
    # Workaround for NVMe controller instability: keep the drive out of deep
    # power states and disable PCIe Active State Power Management.
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"
      "pcie_aspm=off"
    ];

    # nvme0n1p2, holding the LVM PV that vg-root and vg-swap live on.
    initrd.luks.devices.cryptroot = {
      device = "/dev/disk/by-uuid/28d6d42e-3109-4321-9d1a-a59fbac255b3";
      allowDiscards = true;
    };

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
