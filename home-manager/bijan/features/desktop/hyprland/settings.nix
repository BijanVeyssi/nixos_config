{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = with config.theme; {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      "col.inactive_border" = "rgba(00000000)"; # Transparent
      "col.active_border" = "rgb(${colors.purple})";
      layout = "dwindle";
    };

    dwindle = {
      force_split = 2;
      preserve_split = true;
    };

    decoration = {
      rounding = 3;
      shadow.enabled = false;
    };

    animations = {
      enabled = true;
    };

    input = {
      kb_layout = "us,us";
      kb_variant = ",intl";
      kb_options = "grp:win_space_toggle,caps:swapescape";
      repeat_rate = 35;
      repeat_delay = 225;
      touchpad.natural_scroll = true;
    };

    device = [
      {
        name = "zsa-technology-labs-moonlander-mark-i";
        kb_options = "grp:win_space_toggle";
      }
      {
        name = "zsa-technology-labs-voyager";
        kb_options = "grp:win_space_toggle";
      }
    ];

    misc = {
      force_default_wallpaper = 0;
      # Follow activation requests, so clicking a notification or a taskbar
      # entry switches to the workspace the window lives on.
      focus_on_activate = true;
    };

    binds = {
      workspace_center_on = 1;
    };

    exec-once = [
      "hyprctl setcursor Adwaita 16"
      "swaybg -m fill -i ~/.config/nixos_config/background.jpg"
      "systemctl --user restart hypridle.service"
      "exec wl-paste --type text --watch cliphist store"
      "discord"
      "waybar"
      "keepassxc"
      "firefox"
    ];

    "debug.disable_time" =
      false;
    "debug.disable_log" =
      false;

  };
}
