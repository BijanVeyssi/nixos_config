{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    swaybg
  ];

  home.file."Pictures/wallpaper.jpg".source = ./wallpaper.jpg;
}
