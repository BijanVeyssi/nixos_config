{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling = {
        history = 1000;
        multiplier = 5;
      };

      font = {
        normal = {
          family = "Hack Nerd Font Mono";
          style = "Regular";
        };

        bold = {
          family = "Hack Nerd Font Mono";
          style = "Bold";
        };

        italic = {
          family = "Hack Nerd Font Mono";
          style = "Italic";
        };

        bold_italic = {
          family = "Hack Nerd Font Mono";
          style = "Bold Italic";
        };

        size = 8;

        offset = {
          x = 0;
          y = 0;
        };
      };

      colors = {
        # Default colors
        primary = {
          background = "0x24283b";
          foreground = "0xc0caf5";
        };

        # Normal colors
        normal = {
          black = "0x1D202F";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xa9b1d6";
        };

        # Bright colors
        bright = {
          black = "0x414868";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xc0caf5";
        };

        indexed_colors = [
          {
            index = 16;
            color = "0xff9e64";
          }
          {
            index = 17;
            color = "0xdb4b4b";
          }
        ];
      };

      background_opacity = 0.93;

      selection = { save_to_clipboard = true; };

      cursor = {
        style = "Block";
        vi_mode_style = "Block";
        unfocused_hollow = true;
        thickness = 0.15;
      };

      live_config_reload = true;

      shell.program = "${pkgs.fish}/bin/fish";

      working_directory = "None";

      mouse = {
        double_click = { threshold = 300; };
        triple_click = { threshold = 300; };
      };

      hide_when_typing = true;

      hints = {
        launcher = { program = "xdg-open"; };
        modifiers = "Shift";
      };
    };
  };
}
