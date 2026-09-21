{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fira
    fira-code
    fira-mono
    iosevka
    nerd-fonts.hack
    nerd-fonts.iosevka
    noto-fonts-color-emoji
  ];
}
