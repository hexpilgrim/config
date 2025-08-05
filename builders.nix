# builders.nix
{
  nixpkgs,
  home-manager,
  spicetify-nix,
  chaotic,
  nur,
  umu,
  nix-gaming,
  ...
}@inputs:
self:

let
  # Define the system architecture and user configuration
  system = "x86_64-linux";
  user = import ./user.nix;
  defaults = import ./lib/defaults.nix;
  customPkgs = import ./packages { inherit pkgs; };

  # This file is responsible for loading and applying the overlays
  # defined in the flakeRoot/overlays directory
  overlays = import ./lib/overlay-loader.nix {
    inherit system defaults;
    flakeRoot = self;
  };

  # Import the Nixpkgs package set with the specified system architecture
  # and apply the overlays to it
  pkgs = import nixpkgs {
    inherit system;
    overlays = overlays;
    config.allowUnfree = true;
  };

  # Define the Chaotic NixOS modules to be used in the configuration
  chaoticModules = with chaotic.nixosModules; [
    nyx-cache
    nyx-overlay
    nyx-registry
  ];

  # Base modules for the NixOS configuration
  baseModules = [
    ./modules/boot.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  # Function to create a NixOS configuration for the specified system and user
  mkConfig = nixpkgs.lib.nixosSystem {
    inherit system;

    modules =
      baseModules
      ++ chaoticModules
      ++ [
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
    nixos = mkConfig;
  };

  # Expose each overlay-defined package under flake outputs as packages.${system}.${name}
  # The names are derived from defaults.overlayPackageNames, ensuring no hardcoded duplication
  # Each package must be declared in overlays and have a matching attribute in pkgs
  packages.${system} = builtins.listToAttrs (
    (map (name: {
      name = name;
      value = pkgs.${name};
    }) defaults.overlayPackageNames)
    ++ (map (name: {
      name = name;
      value = customPkgs.${name};
    }) (builtins.attrNames customPkgs))
  );

  # Expose the overlays as a single attribute set
  overlays.default = pkgs.lib.composeManyExtensions overlays;

  # Import the NixOS modules for the configuration
  nixosModules.default = ./configuration.nix;
  homeManagerModules.default = ./home.nix;

  # Import the devShells from the dev/default.nix file
  devShells.${system} = import ./dev/default.nix { inherit pkgs; };
}
