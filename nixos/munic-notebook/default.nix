{ pkgs, ... }:

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

  # The 27E1QA on HDMI re-asserts hotplug by itself every ~8s, dropping the
  # connector for ~2s each time, which tears the output down and back up until
  # the screen visibly flickers. The kernel logs nothing and the same
  # compositor is stable on the tower, so pin the connector's state rather than
  # honouring the monitor. The debounce is what keeps unplugging usable: a real
  # unplug leaves EDID gone, a spurious blip has it back within seconds.
  systemd.services.hdmi-hpd-force = {
    description = "Pin the HDMI connector against the 27E1QA's spurious hotplug";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "hdmi-hpd-force" ''
        set -eu

        conn=$(echo /sys/class/drm/card*-HDMI-A-1)
        [ -w "$conn/status" ] || exit 0

        sleep 3

        if grep -aqs 27E1QA "$conn/edid"; then want=on; else want=detect; fi

        state=/run/hdmi-hpd-force.state
        if [ "$(cat "$state" 2>/dev/null || echo detect)" != "$want" ]; then
          echo "$want" > "$conn/status"
          echo "$want" > "$state"
        fi
      '';
    };
  };

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="card[0-9]*", RUN+="${pkgs.systemd}/bin/systemctl --no-block restart hdmi-hpd-force.service"
  '';

  boot = {
    binfmt.emulatedSystems = [ "armv7l-linux" ];

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
