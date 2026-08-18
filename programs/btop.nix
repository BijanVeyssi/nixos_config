{ pkgs, ... }:

{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "tokio_night";
    };
  };
}
