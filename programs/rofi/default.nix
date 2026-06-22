{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    font = "Hack Nerd Font 10";
    plugins = [ pkgs.rofi-emoji ];
    extraConfig = {
      icon-theme = "Papirus";
      show-icons = false;
      display-drun = "";
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = false;
    };
    theme = ./tokyonight.rasi;
  };
}
