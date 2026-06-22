{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = with config.theme; {
    "$MONITOR_L" = "HDMI-A-1";
    "$MONITOR_R" = "eDP-1";

    monitor = [
      "$MONITOR_L,preferred,auto-left,1"
      "$MONITOR_R,preferred,auto,1.33"
    ];

    workspace = [
      "1  ,monitor:$MONITOR_R,persitent:true,default:true"
      "2  ,monitor:$MONITOR_L,persitent:true,default:true"
      "3  ,monitor:$MONITOR_L,persitent:true,default:true"
      "4  ,monitor:$MONITOR_L,persitent:true,default:true"
      "5  ,monitor:$MONITOR_L,persitent:true,default:true"
      "6  ,monitor:$MONITOR_L,persitent:true,default:true"
      "7  ,monitor:$MONITOR_R,persitent:true,default:true"
      "8  ,monitor:$MONITOR_R,persitent:true,default:true"
      "9  ,monitor:$MONITOR_R,persitent:true,default:true"
      "10 ,monitor:$MONITOR_R,persitent:true,default:true"
      "11 ,monitor:$MONITOR_L,persitent:true,default:true"
      "12 ,monitor:$MONITOR_L,persitent:true,default:true"
      "13 ,monitor:$MONITOR_L,persitent:true,default:true"
      "14 ,monitor:$MONITOR_L,persitent:true,default:true"
      "15 ,monitor:$MONITOR_L,persitent:true,default:true"
      "16 ,monitor:$MONITOR_L,persitent:true,default:true"
      "17 ,monitor:$MONITOR_L,persitent:true,default:true"
      "18 ,monitor:$MONITOR_L,persitent:true,default:true"
      "19 ,monitor:$MONITOR_L,persitent:true,default:true"
      "20 ,monitor:$MONITOR_L,persitent:true,default:true"
    ];

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
    };

    binds = {
      workspace_center_on = 1;
    };

    exec-once = [
      "hyprctl setcursor Adwaita 16"
      "swaybg -m fill -i ~/.config/nixos_config/background.jpg"
      "systemctl --user restart hypridle.service"
      "exec wl-paste --type text --watch cliphist store"
      "slack"
      "discord"
      "waybar"
      "keepassxc"
    ];

    "debug.disable_time" =
      false;
    "debug.disable_log" =
      false;

  };
}
