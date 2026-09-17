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

  # Enable the wayland windowing system.
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  # The HDMI link drops every ~8s under aquamarine's atomic modesetting while
  # being stable under Xorg's legacy KMS on the same cable. Force legacy.
  environment.sessionVariables.AQ_DRM_NO_ATOMIC = "1";

  # Graphical greeter, which also drives both outputs from boot.
  services.displayManager.regreet.enable = true;

  # regreet runs under cage, which is wlroots rather than aquamarine, so it
  # needs the wlroots spelling of the flag above or the greeter flaps too.
  systemd.services.greetd.environment.WLR_DRM_NO_ATOMIC = "1";


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

  # Systemd
  systemd.user = {
    services = {
      nix-gc = {
        description = "Garbage collection for user profiles";
        script = "/run/current-system/sw/bin/nix-collect-garbage --delete-older-than 7d";
        startAt = "daily";
      };

      mdmd = {
        enable = true;
        unitConfig = {
          Description = "Munic Device Manager Daemon";

          # Ask for graphical interface and the dbus socket.
          Wants = "graphical.target dbus.socket mdmd.socket xdg-desktop-autostart.target";
          After = "graphical.target dbus.socket mdmd.socket xdg-desktop-autostart.target";
        };
        serviceConfig = {
          PermissionsStartOnly = "false";
          Sockets = "mdmd.socket";
          StandardInput = "socket";
          StandardError = "journal";
          Environment = [
            "PATH=/run/wrappers/bin/:/etc/profiles/per-user/bijan/bin/:/run/current-system/sw/bin/"
            "TERM=alacritty"
          ];
          ExecStart = "/home/bijan/mdmd/target/debug/mdmd";
          Type = "simple";
          RemainAfterExit = "false";
          Restart = "always";
          RestartSec = "1s";
          TimeoutSec = "180";
        };
        wantedBy = [ "default.target" ];
      };

    };
    sockets = {
      mdmd = {
        socketConfig = {
          ListenFIFO = "%t/mdmd/mdmd.stdin";
          Service = "mdmd.service";
        };
      };
    };
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
