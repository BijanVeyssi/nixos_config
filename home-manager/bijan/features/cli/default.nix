{ pkgs, ... }:

{
  imports = [
    ./btop.nix
    ./direnv.nix
    ./fish.nix
    ./python.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    asciiquarium
    cmatrix
    file
    fzf
    htop
    jq
    lnav
    man-pages
    pamixer
    pipes
    playerctl
    rclone
    ripgrep
    sl
    tmux
    tree
    unzip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };
}
