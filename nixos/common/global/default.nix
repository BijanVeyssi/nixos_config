{ inputs, outputs, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./locale.nix
    ./nix.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future.
  networking.useDHCP = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dig
    efibootmgr
    git
    sbctl
    iproute2
    iptables
    nftables
    ppp
    sshpass
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];
}
