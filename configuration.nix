# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot = {
    # Workaround for NVMe controller instability: keep the drive out of deep
    # power states and disable PCIe Active State Power Management.
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"
      "pcie_aspm=off"
    ];

    initrd.luks.devices.cryptroot = {
      device = "/dev/disk/by-label/cryptroot";
      preLVM = true;
      allowDiscards = true;
    };

    kernel = {
      sysctl = {
        "kernel.core_pattern" = "/var/crash/core.%t.%p";
        "kernel.panic" = 10;
        "kernel.unknown_nmi_panic" = 1;
      };
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
    settings.auto-optimise-store = true;
    # Detects files with identical content in store and replace them with hard links to a single copy
  };

  networking.hostName = "Bijan-Nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.extraHosts =
    ''
      10.42.42.208 	releases.system.mdi
      10.42.42.208 	docs.system.mdi
      10.42.42.208 	packages.system.mdi
    '';

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  # This registers the only session entry LightDM can offer; without it the
  # session list is empty and login fails. The session wrapper execs
  # ~/.xsession when present, so home-manager's bspwm config still takes over.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.bspwm.enable = true;

  # Fix for some x11 apps
  programs.nix-ld = {
    libraries = with pkgs; [
      libx11
      libxcursor
      libxcb
      libxi
      libxkbcommon
    ];
    enable = true;
  };


  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    options = "caps:escape";
    layout = "us";
  };
  services.xserver.autoRepeatDelay = 220;
  services.xserver.autoRepeatInterval = 35;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };
  hardware.alsa.enablePersistence = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.renken = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "jackaudio" "audio" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bijan = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "jackaudio" "audio" ];
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

  programs.fish.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dig
    ppp
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    sshpass
    firefox
    qutebrowser
    pavucontrol
    iproute2
    iptables
    nftables
    efibootmgr
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # PAM service used by betterlockscreen's i3lock-color (configured per-user
  # via home-manager's services.screen-locker).
  security.pam.services.i3lock.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
    '';
  };

  # Udev rules
  services.udev = {
    extraRules = ''
      # Atmel DFU
      ### ATmega16U2
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2fef", TAG+="uaccess"
      ### ATmega32U2
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", TAG+="uaccess"
      ### ATmega16U4
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff3", TAG+="uaccess"
      ### ATmega32U4
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"
      ### AT90USB64
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff9", TAG+="uaccess"
      ### AT90USB162
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffa", TAG+="uaccess"
      ### AT90USB128
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffb", TAG+="uaccess"

      # Input Club
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1c11", ATTRS{idProduct}=="b007", TAG+="uaccess"

      # STM32duino
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="0003", TAG+="uaccess"
      # STM32 DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"

      # BootloadHID
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", TAG+="uaccess"

      # USBAspLoader
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", TAG+="uaccess"

      # USBtinyISP
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1782", ATTRS{idProduct}=="0c9f", TAG+="uaccess"

      # ModemManager should ignore the following devices
      # Atmel SAM-BA (Massdrop)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

      # Caterina (Pro Micro)
      ## pid.codes shared PID
      ### Keyboardio Atreus 2 Bootloader
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2302", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ## Spark Fun Electronics
      ### Pro Micro 3V3/8MHz
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9203", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ### Pro Micro 5V/16MHz
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9205", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ### LilyPad 3V3/8MHz (and some Pro Micro clones)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9207", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ## Pololu Electronics
      ### A-Star 32U4
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1ffb", ATTRS{idProduct}=="0101", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ## Arduino SA
      ### Leonardo
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ### Micro
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ## Adafruit Industries LLC
      ### Feather 32U4
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000c", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ### ItsyBitsy 32U4 3V3/8MHz
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000d", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ### ItsyBitsy 32U4 5V/16MHz
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000e", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ## dog hunter AG
      ### Leonardo
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
      ### Micro
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

      # hid_listen
      KERNEL=="hidraw*", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

      # hid bootloaders
      ## QMK HID
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2067", TAG+="uaccess"
      ## PJRC's HalfKay
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0478", TAG+="uaccess"

      # APM32 DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="314b", ATTRS{idProduct}=="0106", TAG+="uaccess"

      # GD32V DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", TAG+="uaccess"

      # WB32 DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="dfa0", TAG+="uaccess"
    '';
  };

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
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  nixpkgs.config =
    {
      allowUnfree = true;

    };
}
