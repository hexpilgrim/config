# flake.nix
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = import ./user.nix;
      defaults = import ./lib/defaults.nix;

      overlays = import ./lib/overlay-loader.nix {
        inherit system defaults;
      };

      # Apply overlays and enable unfree packages
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      mkConfig =
        isLocal:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit isLocal;
          };

          modules = [
            ./modules/boot.nix
            ./configuration.nix
            ./hardware-configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${user.username} = import ./home.nix {
                inherit
                  pkgs
                  spicetify-nix
                  user
                  system
                  ;
                lib = pkgs.lib;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos = mkConfig true;
        garnix = mkConfig false;
      };

      # Expose each overlay-defined package under flake outputs as packages.${system}.${name}
      # The names are derived from defaults.overlayPackageNames, ensuring no hardcoded duplication
      # Each package must be declared in overlays and have a matching attribute in pkgs
      packages.${system} = builtins.listToAttrs (
        map (name: {
          name = name;
          value = pkgs.${name};
        }) defaults.overlayPackageNames
      );
    };
}
