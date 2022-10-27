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
    BROWSER = "firefox";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    DRI_PRIME = 1;
    __NV_PRIME_RENDER_OFFLOAD = 1;
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    PROTON_LOG=1;
    PROTON_USE_WINED3D=1;
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
    neofetch

    # Utility
    flameshot
    brightnessctl
    playerctl
    redshift
    xclip
    unzip
    arandr
    man-pages

    pandoc
    texlive.combined.scheme-full
    fira
    fira-mono
    fira-code

    # Apps
    discord
    spotify
    thunderbird
    slack
    feh
    zathura
    font-manager
    lxappearance
    teams
    bluez

    # Dev
    gcc
    gdb
    gnumake
    neovim
    nixfmt
    stylua
    rustfmt
    clang-tools
    sumneko-lua-language-server
    rust-analyzer
    texlab
    bear
    cmake
    cargo
    valgrind

    # Formatters and language servers
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.pyright
    rust-analyzer
    rustfmt
    stylua
    sumneko-lua-language-server
    texlab

    # Fonts/Theme
    (nerdfonts.override { fonts = [ "Hack" ]; })
    iosevka
    noto-fonts-emoji
    papirus-icon-theme

    # Fun
    sl
    asciiquarium
    pipes
    steam
    gimp
  ];

  imports = [ ./programs ];

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
