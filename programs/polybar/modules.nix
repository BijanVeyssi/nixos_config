pkgs: colors:

{
  "module/left" = {
    type = "custom/text";

    content = {
      text = "%{T2}%{T-}";
      foreground = colors.terminal_black;
    };
  };

  "module/right" = {
    type = "custom/text";

    content = {
      text = "%{T2}%{T-}";
      foreground = colors.terminal_black;
    };
  };

  "module/space" = {
    type = "custom/text";

    content = " ";
  };

  "module/bspwm" = {
    type = "internal/bspwm";

    format = "<label-state><label-mode>";
    format-background = colors.terminal_black;

    enable-click = true;
    enable-scroll = true;
    reverse-scroll = true;
    pin-workspaces = true;

    ws-icon-default = "";

    label-focused = "";
    label-focused-foreground = colors.foreground;
    label-focused-padding = 1;

    label-empty = "";
    label-empty-foreground = colors.background;
    label-empty-padding = 1;

    label-occupied = "";
    label-occupied-foreground = colors.magenta;
    label-occupied-padding = 1;

    label-urgent = "";
    label-urgent-foreground = colors.red;
    label-urgent-padding = 1;

    label-monocle = "";
    label-monocle-foreground = colors.background;
    label-monocle-padding-left = 1;

    label-tiled = "";
    label-tiled-foreground = colors.background;
    label-tiled-padding-left = 1;

    label-fullscreen = "";
    label-fullscreen-foreground = colors.background;
    label-fullscreen-padding-left = 1;

    label-floating = "";
    label-floating-foreground = colors.background;
    label-floating-padding-left = 1;

    label-pseudotiled = "";
    label-pseudotiled-foreground = colors.background;
    label-pseudotiled-padding-left = 1;

    label-locked = "";
    label-locked-foreground = colors.background;
    label-locked-padding-left = 1;

    label-sticky = "";
    label-sticky-foreground = colors.background;
    label-sticky-padding-left = 1;

    label-private = "";
    label-private-foreground = colors.background;
    label-private-padding-left = 1;
  };

  "module/xkeyboard" = {
    type = "internal/xkeyboard";

    label-layout = "%icon%";

    layout-icon-default = "";
    layout-icon-0 = "us;_;us";
    layout-icon-1 = "us;intl;us_intl";

    format = {
      text = "<label-layout>";
      foreground = colors.fg_dark;
      background = colors.background;
    };
  };

  "module/xwindow" = {
    type = "internal/xwindow";

    label = {
      text = "%title%";
      maxlen = 45;
    };

    format = {
      foreground = colors.fg_dark;
      background = colors.background;
    };
  };

  "module/previous" = {
    type = "custom/script";

    interval = 86400;
    exec = "echo ' '";
    line-size = 1;
    click-left = "${pkgs.dbus}/bin/dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";

    format = {
      text = "%{T3}<label>";
      foreground = colors.fg_dark;
      background = colors.terminal_black;
    };
  };

  "module/spotify" = {
    type = "custom/script";

    interval = 1;
    exec = "~/.config/polybar/scripts/spotify_status.py -f '{play_pause} {artist} - {song}' -p ',' -t 25";
    click-left = "${pkgs.dbus}/bin/dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
    click-right = "${pkgs.bspwm}/bin/bspc desktop --focus 10";

    format = {
      text = "<label>";
      foreground = "#1db954";
      background = colors.terminal_black;
    };
  };

  "module/next" = {
    type = "custom/script";

    interval = 86400;
    exec = "echo ' '";
    line-size = 1;
    click-left = "${pkgs.dbus}/bin/dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";

    format = {
      text = "%{T3}<label>";
      foreground = colors.fg_dark;
      background = colors.terminal_black;
    };
  };

  "module/date" = {
    type = "internal/date";

    interval = 1;
    date = "";
    date-alt = "%d-%m-%Y ";
    time = "%H:%M";
    time-alt = "%H:%M:%S";
    label = " %date%%time%";

    format = {
      foreground = colors.red;
      background = colors.terminal_black;
    };
  };

  "module/pulseaudio" = {
    type = "internal/pulseaudio";
    use-ui-max = true;
    interval = 5;

    label = {
      volume = " %percentage%%";
      muted = " 0%";
    };

    format = {
      volume = {
        text = "<label-volume>";
        foreground = colors.green;
        background = colors.terminal_black;
      };
      muted = {
        foreground = colors.green;
        background = colors.terminal_black;
      };
    };

    click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
  };

  "module/redshift" = {
    type = "custom/script";

    exec = "source ~/.config/polybar/scripts/env.sh && ~/.config/polybar/scripts/redshift.sh temperature";
    click-left = "source ~/.config/polybar/scripts/env.sh && ~/.config/polybar/scripts/redshift.sh toggle";
    scroll-up = "source ~/.config/polybar/scripts/env.sh && ~/.config/polybar/scripts/redshift.sh increase";
    scroll-down = "source ~/.config/polybar/scripts/env.sh && ~/.config/polybar/scripts/redshift.sh decrease";
    interval = 0.5;

    format = {
      prefix = " ";
      foreground = colors.yellow;
      background = colors.terminal_black;
    };
  };

  "module/brightness" = {
    type = "internal/backlight";

    card = "intel_backlight";
    label = "%percentage%%";
    ramp-0 = "%{T1}%{T-}";

    format = {
      text = "%{A1:brightnessctl s 1%:}%{A2:brightnessctl s 30%:}%{A3:brightnessctl s 100%:}%{A4:brightnessctl s +5%:}%{A5:brightnessctl s 5%-:}<ramp> <label>%{A}%{A}%{A}%{A}%{A}";
      foreground = colors.blue;
      background = colors.terminal_black;
    };
  };

  "module/battery-one" = {
    type = "internal/battery";

    full-at = 99;
    battery = "BAT0";
    poll-interval = 5;

    label = {
      discharging = " %percentage%%";
      charging = " %percentage%%";
      full = " %percentage%%";
    };

    format = {
      discharging = {
        foreground = colors.cyan;
        background = colors.terminal_black;
      };

      charging = {
        foreground = colors.cyan;
        background = colors.terminal_black;
      };

      full = {
        foreground = colors.cyan;
        background = colors.terminal_black;
      };
    };
  };

  "module/battery-two" = {
    type = "internal/battery";

    full-at = 99;
    battery = "BAT1";
    poll-interval = 5;

    label = {
      discharging = " %percentage%%";
      charging = " %percentage%%";
      full = " %percentage%%";
    };

    format = {
      discharging = {
        foreground = colors.teal;
        background = colors.terminal_black;
      };

      charging = {
        foreground = colors.teal;
        background = colors.terminal_black;
      };

      full = {
        foreground = colors.teal;
        background = colors.terminal_black;
      };
    };
  };
}
