{ pkgs, inputs }:

{
  wofi-power-menu = pkgs.callPackage ./wofi-power-menu.nix { };
}
