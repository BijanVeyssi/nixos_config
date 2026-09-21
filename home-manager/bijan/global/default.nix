{ lib, config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    # Under the NixOS module the line above installs nothing, so the command
    # has to come from nixpkgs. Standalone it would collide with the package
    # home-manager builds for itself.
    packages = lib.optional config.submoduleSupport.enable pkgs.home-manager;

    username = lib.mkDefault "bijan";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = lib.mkDefault "22.05";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };
}
