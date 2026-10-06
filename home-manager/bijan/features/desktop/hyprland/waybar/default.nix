{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings =
      let
        modules = import ./modules.nix { inherit config; inherit pkgs; };
      in
      {
        mainBar = {
          position = "top";

          modules-left = [
            "hyprland/workspaces"
            "custom/window-state"
          ];
          modules-center = [
            "mpris"
          ];
          modules-right = [
            "hyprland/language"
            "clock"
            "wireplumber"
            "backlight"
            "battery"
            "tray"
          ];
        } // modules;
      };

    style = import ./style.nix config.theme.colors;
  };
}
