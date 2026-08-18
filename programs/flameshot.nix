{ pkgs, ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General.useX11LegacyScreenshot = true; # necessary to avoid "portal" issues on XMonad
    };
  };
}
