{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bijan = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "jackaudio" "audio" ];
  };

  home-manager.users.bijan =
    import ../../../../home-manager/bijan/${config.networking.hostName}.nix;
}
