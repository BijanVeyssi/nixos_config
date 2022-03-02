{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display
        monitor = 1;
        follow = "mouse";
        width = 350;
        notification_limit = 6;
        origin = "top-right";
        offset = "5x35";
        indicate_hidden = true;
        shrink = false;
        transparency = 15;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 10;
        frame_width = 0;
        frame_color = "#414868";
        separator_color = "frame";
        sort = true;
        idle_threshold = 120;

        # Text
        font = "Hack Nerd Font 10";
        line_height = 0;
        markup = "full";
        format = ''
          %s %p
          %b'';
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        icon_position = false;
        min_icon_size = 32;
        max_icon_size = 64;
        icon_path =
          "/home/stolen/.icons/tokyonight/status/22:/home/stolen/.icons/tokyonight/devices/22:/home/stolen/.icons/tokyonight/panel/22";

        # History
        sticky_history = true;
        history_length = 20;

        # Misc/Advanced
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 5;
        ignore_dbusclose = false;
        force_xinerama = false;

        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "do_action, close_current";
      };

      experimental.per_monitor_dpi = false;

      urgency_low = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        timeout = 10;
      };

      urgency_normal = {
        background = "#1a1b26";
        foreground = "#7aa2f7";
        timeout = 10;
      };

      urgency_critical = {
        background = "#1a1b26";
        foreground = "#f7768e";
        timeout = 0;
      };
    };
  };
}
