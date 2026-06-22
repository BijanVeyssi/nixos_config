{ config, lib, pkgs, ... }:

let
  colorschemes = rec {
    tokyonight-storm = {
      bg = "24283b";
      bg_dark = "1f2335";
      bg_darker = "1a1b26";
      bg_selection = "2e3c64";
      black = "1d202f";
      blue = "7aa2f7";
      comment = "565f89";
      cyan = "7dcfff";
      fg = "c0caf5";
      fg_dark = "a9b1d6";
      green = "9ece6a";
      magenta = "bb9af7";
      orange = "ff9e64";
      purple = "9d7cd8";
      red = "f7768e";
      terminal_black = "414868";
      yellow = "e0af68";
    };
    tokyonight-night = tokyonight-storm // {
      bg = "1a1b26";
      bg_dark = "16161e";
      bg_darker = "000000";
      bg_selection = "283457";
      black = "15161e";
    };
  };
in
{
  options = with lib; {
    theme.name = mkOption {
      description = "colorscheme name";
      type = with types; uniq str;
      default = "tokyonight-storm";
    };
    theme.colors = mkOption {
      type = with types; attrsOf str;
      default = null;
    };
  };

  config = {
    theme.colors = colorschemes.${config.theme.name};
  };

  imports = [
    ./fonts.nix
    ./wallpaper.nix
    ./gtk.nix
  ];
}
