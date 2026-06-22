{ config, pkgs, ... }:

{
  "hyprland/workspaces" = {
    format = "{icon}";
    format-icons = {
      default = "";
      empty = "";
      active = "";
    };
    on-scroll-up = "hyprctl dispatch workspace m-1";
    on-scroll-down = "hyprctl dispatch workspace m+1";
  };

  "custom/window-state" =
    let
      windowStateScript =
        pkgs.callPackage ./scripts/window-state.nix { } + "/bin/window-state.sh";
    in
    {
      exec = windowStateScript;
      interval = 1;
      tooltip = false;
    };

  mpris = {
    player = "chromium"; # tidal-hifi
    format = "{status_icon}  {artist} - {title}";
    status-icons = {
      playing = "";
      paused = "";
    };
    tooltip = false;
    on-click-right = "hyprctl dispatch workspace 10";
  };

  "custom/kblayout" = {
    exec =
      ''[ "$(hyprctl devices | grep 'US, intl')" ] && echo us_intl || echo us'';
    interval = 1;
    tooltip = false;
  };

  clock = {
    interval = 1;
    format = "  {:%H:%M}";
    format-alt = "  {:%d/%m/%Y %H:%M:%S}";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "month";
      format = with config.theme; {
        months = "<span color='#${colors.fg}'><b>{}</b></span>";
        days = "<span color='#${colors.fg}'><b>{}</b></span>";
        weekdays = "<span color='#${colors.yellow}'><b>{}</b></span>";
        today = "<span color='#${colors.red}'><b><u>{}</u></b></span>";
      };
    };
    actions = {
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
      on-click-right = "shift_reset";
    };
  };

  wireplumber = {
    format = "{icon}  {volume}%";
    format-muted = "  {volume}%";
    format-icons = [ "" "" "" ];
    scroll-step = 5.0;
    tooltip = false;
    on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
  };

  backlight = {
    format = "{icon}  {percent}%";
    format-icons = [ "󰃞" "󰃟" "󰃠" ];
    scroll-step = 5.0;
    tooltip = false;
  };

  battery = {
    format = "{icon}  {capacity}%";
    format-charging = "{icon} 󱐋 {capacity}%";
    format-icons = [ "" "" "" "" "" ];
  };
}
