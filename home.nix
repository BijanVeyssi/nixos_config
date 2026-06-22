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
    CM_LAUNCHER = "rofi";
  };

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

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
    brightnessctl
    flameshot
    fzf
    home-manager
    jq
    keepassxc
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
    stylua
    bear
    cmake
    pre-commit
    nix-direnv
    direnv
    tmux
    black
    shellcheck

    # Munic Specifix
    icecream
    asciidoctor
    can-utils
    daemontools

    # Formatters and language servers
    nixpkgs-fmt
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
