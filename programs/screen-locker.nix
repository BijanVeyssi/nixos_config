{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.xss-lock pkgs.betterlockscreen ];

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
  };
}
