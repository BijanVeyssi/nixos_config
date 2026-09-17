{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bijan";
  home.homeDirectory = "/home/bijan";
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "qutebrowser";
  };

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
  xdg.userDirs.setSessionVariables = true;

  fonts.fontconfig.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Shell
    htop
    cmatrix
    tree
    ripgrep
    file

    # Utility
    arandr
    home-manager
    keepassxc
    texliveFull
    fzf
    jq
    libnotify
    lnav
    man-pages
    markdownlint-cli
    nix-search-cli
    pamixer
    pandoc
    playerctl
    rclone
    texlive.combined.scheme-full
    unzip
    wl-clipboard
    cliphist

    # Fonts
    fira
    fira-mono
    fira-code

    # Apps
    discord
    slack
    feh
    zathura
    font-manager
    lxappearance
    bluez

    # Dev
    nil
    go
    gcc
    clang-tools
    gnumake
    neovim
    nixfmt
    bear
    cmake
    pre-commit
    tmux
    black
    shellcheck

    # Munic Specifix
    icecream
    asciidoctor
    can-utils
    daemontools

    # Formatters and language servers
    stylua
    lua-language-server
    texlab

    # Fonts/Theme
    nerd-fonts.hack
    iosevka
    noto-fonts-color-emoji
    papirus-icon-theme

    # Fun
    sl
    asciiquarium
    pipes
    steam
    gimp
  ];

  imports = [ ./programs ./themes ];

  services.network-manager-applet.enable = true;

  services.clipmenu = {
    enable = true;
    launcher = "rofi";
  };
  systemd.user.services.clipmenu.Service.Environment = [ "CM_IGNORE_WINDOW=KeePass|nvim" ];

  systemd.user.services.mdmd = {
    Unit = {
      Description = "Munic Device Manager Daemon";

      # Ask for graphical interface and the dbus socket.
      Wants = "graphical-session.target dbus.socket mdmd.socket xdg-desktop-autostart.target";
      After = "graphical-session.target dbus.socket mdmd.socket xdg-desktop-autostart.target";
    };
    Service = {
      Sockets = "mdmd.socket";
      StandardInput = "socket";
      StandardError = "journal";
      Environment = [
        "PATH=/run/wrappers/bin/:${config.home.profileDirectory}/bin/:/run/current-system/sw/bin/"
        "TERM=alacritty"
      ];
      ExecStart = "${config.home.homeDirectory}/mdmd/target/debug/mdmd";
      Type = "simple";
      Restart = "always";
      RestartSec = "1s";
      TimeoutSec = "180";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.sockets.mdmd = {
    Socket = {
      ListenFIFO = "%t/mdmd/mdmd.stdin";
      Service = "mdmd.service";
    };
    Install.WantedBy = [ "sockets.target" ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
