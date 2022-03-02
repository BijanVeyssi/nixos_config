{
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;

      monitors = { eDP-1 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ]; };

      settings = {
        border_width = 1;
        focused_border_color = "#9d7cd8";
        window_gap = 10;
        split_ratio = 0.5;
        focus_follows_pointer = true;
        pointer_follows_monitor = true;
      };

      rules = {
        "Spotify".desktop = "10";
        "discord".desktop = "9";
        "Thunderbird".desktop = "8";
        "Slack".desktop = "7";

        "Font-manager".state = "floating";
        "Pavucontrol".state = "floating";
        "Zathura".state = "tiled";
      };

      startupPrograms = [
        "feh --bg-fill ~/Pictures/tiger.jpg"
        "spotify"
        "discord"
        "thunderbird"
        "flameshot"
      ];
    };
  };
}
