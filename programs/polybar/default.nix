{ config, pkgs, ... }:

{
  services.polybar =
    let
      colors = {
        transparent = "#00000000";
        background = "#24283b";
        foreground = "#c0caf5";

        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        purple = "#9d7cd8";
        cyan = "#7dcfff";
        magenta = "#bb9af7";
        teal = "#1abc9c";
        fg_dark = "#a9b1d6";
        terminal_black = "#414868";
      };
      fonts = {
        small = [
          "Iosevka:style=Bold:size=9.5;4"
          "Iosevka:style=Bold:size=11.875;3"
          "Symbols Nerd Font:style=Bold:size=9.5;3"
        ];
        big = [
          "Iosevka:style=Bold:size=12;4"
          "Iosevka:style=Bold:size=15;3"
          "Symbols Nerd Font:style=Bold:size=12;4"
        ];
      };
      config = import ./config.nix colors fonts;
      modules = import ./modules.nix pkgs colors;
    in
    {
      enable = true;
      package = pkgs.polybarFull;
      settings = config // modules;
      script = "polybar mainbar &";
    };

  home.file = {
    ".config/polybar/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
