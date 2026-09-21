{
  description = "Bijan's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      systems = [ "x86_64-linux" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = nixpkgs.lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = builtins.attrValues outputs.overlays;
        });
    in
    {
      # Custom packages, accessible through 'nix build', 'nix shell', ...
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs inputs; });

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs outputs; };

      # Reusable nixos modules to possibly export
      # These are usually stuff to upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules to possibly export
      # These are usually stuff to upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configurations entrypoint
      # Available through 'nixos-rebuild --flake .#configName'
      nixosConfigurations = {
        munic-notebook = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/munic-notebook ];
        };
      };

      # Standalone home-manager configurations entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "bijan@munic-notebook" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home-manager/bijan/munic-notebook.nix ];
        };
      };
    };
}
