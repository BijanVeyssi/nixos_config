{ config, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = ./config.ini;
    script = "polybar mainbar &";
  };

  home.file = {
    ".config/polybar/colors.ini".source = ./colors.ini;
    ".config/polybar/modules.ini".source = ./modules.ini;
    ".config/polybar/fonts.ini".source = ./fonts.ini;
    ".config/polybar/fonts-big.ini".source = ./fonts-big.ini;
    ".config/polybar/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
