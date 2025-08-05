# outputs.nix
{
  nixpkgs,
  home-manager,
  chaotic,
  spicetify-nix,
  nur,
  umu,
  nix-gaming,
  disko,
  flake-parts,
  flake-utils,
  nix-index,
  nixos-hardware,
  catppuccin,
  ...
}@inputs:
self:

let
  system = "x86_64-linux";
  user = import ./user.nix;
  defaults = import ./lib/defaults.nix;
  flakeRoot = self;

  overlays = import ./lib/overlay-loader.nix {
    inherit system defaults;
    flakeRoot = self;
  };

  pkgs = import nixpkgs {
    inherit system;
    overlays = overlays;
    config.allowUnfree = true;
  };

  customPkgs = import ./packages { inherit pkgs; };

  baseModules = [
    ./modules/boot.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  chaoticModules = with chaotic.nixosModules; [
    nyx-cache
    nyx-overlay
    nyx-registry
  ];

  builders = import ./builders.nix (
    inputs
    // {
      flakeRoot = self;
      pkgs = pkgs;
      system = system;
    }
  );

  mkConfig = builders.mkSystem {
    inherit
      system
      user
      flakeRoot
      overlays
      baseModules
      ;
    extraModules = chaoticModules;
  };
in
{
  nixosConfigurations.nixos = mkConfig;

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

  overlays.default = pkgs.lib.composeManyExtensions overlays;

  nixosModules.default = ./configuration.nix;
  homeManagerModules.default = ./home.nix;

  devShells.${system} = import ./dev/default.nix { inherit pkgs; };
}
