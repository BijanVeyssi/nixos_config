{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      # Purple accent to stay close to the tokyonight palette in ./default.nix.
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = [ "purple" ];
        colorVariants = [ "dark" ];
      };
      name = "Colloid-Purple-Dark";
    };
    iconTheme = {
      package = pkgs.colloid-icon-theme;
      name = "Colloid-Dark";
    };
  };
}
