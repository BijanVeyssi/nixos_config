colors: fonts:
{
  settings = {
    screenchange-reload = true;

    compositing = {
      background = "over";
      foreground = "over";
      overline = "over";
      underline = "over";
      border = "over";
    };
  };

  "bar/top_bar" = {
    override-redirect = false;
    wm-restack = "bspwm";

    font = fonts.big;

    monitor = "DP-2";
    monitor-strict = false;
    bottom = false;
    fixed-center = true;
    width = "100%";
    height = 27;
    line-size = 3;
    border-top-size = 4;
    border-top-color = colors.background;
    border-bottom-size = 4;
    border-bottom-color = colors.background;
    module-margin = 0;

    background = colors.background;
    foreground = colors.foreground;

    modules-left = "bspwm right space xkeyboard";
    modules-center = "";
    modules-right = "left date right space left pulseaudio right space left redshift right space left";

    tray-detached = false;
    tray-maxsize = 20;
    tray-position = "right";
    tray-background = colors.terminal_black;

    scroll-up = "#bspwm.prev";
    scroll-down = "#bspwm.next";
    cursor-click = "pointer";
  };

  "bar/top_bar2" = {
    override-redirect = false;
    wm-restack = "bspwm";

    font = fonts.big;

    monitor = "DP-5";
    monitor-strict = false;
    bottom = false;
    fixed-center = true;
    width = "100%";
    height = 27;
    line-size = 3;
    border-top-size = 4;
    border-top-color = colors.background;
    border-bottom-size = 4;
    border-bottom-color = colors.background;
    module-margin = 0;

    background = colors.background;
    foreground = colors.foreground;

    modules-left = "bspwm right space xkeyboard";
    modules-center = "";
    modules-right = "left date right space left pulseaudio right space left redshift right space left";

    scroll-up = "#bspwm.prev";
    scroll-down = "#bspwm.next";
    cursor-click = "pointer";
  };
}
