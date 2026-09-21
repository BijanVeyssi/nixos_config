{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
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
          # Only the main window carries the database filename. Dialogs such as
          # the unlock prompt share the class but not the title, so they are
          # left alone and open on whichever workspace is active.
          initial_title = ".*\\.kdbx.*";
        };
        workspace = "10";
      }
    ];
  };
}
