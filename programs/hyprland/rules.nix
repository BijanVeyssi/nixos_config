{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      {
        name = "slack";
        match = {
          class = "slack";
        };
        workspace = "8";
      }
      {
        name = "discord";
        match = {
          class = "discord";
        };
        workspace = "9";
      }
      {
        name = "keepassxc";
        match = {
          class = "org.keepassxc.KeePassXC";
        };
        workspace = "10";
      }
    ];
  };
}
