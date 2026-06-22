{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.iosevka
  ];
}
