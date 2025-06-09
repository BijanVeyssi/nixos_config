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
    kernel = {
      sysctl = {
        "kernel.core_pattern" = "/var/crash/core.%t.%p";
        "kernel.panic" = 10;
        "kernel.unknown_mni_panic" = 1;
      };
    };
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
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

  # Automatic garbage collection (user profiles)

  networking.hostName = "Bijan-Nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Nftables
  networking.nftables = {
    ruleset = ''
      # Check out https://wiki.nftables.org/ for better documentation.
      # Table for both IPv4 and IPv6.
      table inet filter {
        # Block all incoming connections traffic except SSH and "ping".
        chain input {
          type filter hook input priority 0;
  
          # accept any localhost traffic
          iifname lo accept
  
          # accept traffic originated from us
          ct state {established, related} accept
  
          # ICMP
          # routers may also want: mld-listener-query, nd-router-solicit
          ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
          ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept
  
          # allow "ping"
          ip6 nexthdr icmpv6 icmpv6 type echo-request accept
          ip protocol icmp icmp type echo-request accept
  
          # accept SSH connections (required for a server)
          tcp dport 22 accept
  
          # count and drop any other traffic
          counter drop
        }
  
        # Allow all outgoing connections.
        chain output {
          type filter hook output priority 0;
          accept
        }
  
        chain forward {
          type filter hook forward priority 0;
          accept
        }
      }
    '';
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.bspwm.enable = true;

  # Fix for some x11 apps
  programs.nix-ld = {
    libraries = with pkgs; [
      xorg.libX11
      xorg.libXcursor
      xorg.libxcb
      xorg.libXi
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
  services.jack = {
    alsa.enable = true;
    # support ALSA only programs via loopback device (supports programs like Steam)
    loopback = {
      enable = true;
      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #dmixConfig = ''
      #  period_size 2048
      #'';
    };
  };

  services.actkbd =
    let
      volumeStep = "1%";
    in
    {
      enable = true;
      bindings = [
        # "Mute" media key
        { keys = [ 113 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle"; }

        # "Lower Volume" media key
        { keys = [ 114 ]; events = [ "key" "rep" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master ${volumeStep}- unmute"; }

        # "Raise Volume" media key
        { keys = [ 115 ]; events = [ "key" "rep" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master ${volumeStep}+ unmute"; }

        # "Mic Mute" media key
        { keys = [ 190 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Capture toggle"; }
      ];
    };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.renken = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "vboxusers" "docker" "jackaudio" "audio" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bijan = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "vboxusers" "docker" "jackaudio" "audio" ];
  };

  security.sudo.extraConfig = ''
    %wheel       ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/iptables,/run/current-system/sw/bin/nft,/run/current-system/sw/bin/ip
  '';

  programs.fish.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    sshpass
    networkmanagerapplet
    networkmanager
    firefox
    pavucontrol
    iproute2
    iptables
    nftables
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # i3lock
  programs.i3lock.enable = true;
  security.pam.services.i3lock.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  virtualisation.virtualbox.host.enable = true;
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

  # Enable jack audio
}
