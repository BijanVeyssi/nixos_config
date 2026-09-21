{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./dunst.nix
    ./rofi
    ./wofi.nix
  ];

  services.network-manager-applet.enable = true;

  home.packages = with pkgs; [
    arandr
    bluez
    cliphist
    discord
    feh
    font-manager
    gimp
    grimblast
    keepassxc
    libnotify
    lxappearance
    papirus-icon-theme
    slack
    steam
    wl-clipboard
    zathura
  ];
}
