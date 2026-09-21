{ config, lib, pkgs, ... }:

{
  programs.hyprlock = with config.theme; {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = "./background.jpg";
          blur_passes = 3;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          outer_color = "rgb(${colors.bg_dark})";
          inner_color = "rgb(${colors.bg_dark})";
          font_color = "rgb(${colors.fg})";
          fade_on_empty = false;
          placeholder_text = ''<i><span font_family="Hack Nerd Font" foreground="##${colors.comment}">Input Password...</span></i>'';
          check_color = "rgb(${colors.yellow})";
          fail_color = "rgb(${colors.red})";
          position = "0, -70";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgb(${colors.fg})";
          font_size = 120;
          font_family = "Hack Nerd Font ExtraBold";
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
