# outputs.nix
{ inputs, self, ... }:

let
  system = "x86_64-linux";
  user = import ./user.nix;
  defaults = import ./lib/defaults.nix;
  flakeRoot = self;

  overlays = import ./lib/overlay-loader.nix {
    inherit system defaults flakeRoot;
  };

  pkgs = import ./lib/pkgs.nix {
    nixpkgs = inputs.nixpkgs;
    inherit system overlays;
  };

  customPkgs = import ./packages { inherit pkgs; };

  baseModules = [
    ./modules/boot.nix
    (import ./configuration.nix)
    ./hardware-configuration.nix
  ];

  chaoticModules = with inputs.chaotic.nixosModules; [
    nyx-cache
    nyx-overlay
    nyx-registry
  ];

  constructors = import ./constructors.nix (
    inputs
    // {
      inherit flakeRoot pkgs system;
    }
  );

  mkConfig = constructors.mkSystem {
    inherit
      system
      user
      flakeRoot
      overlays
      baseModules
      ;
    extraModules = chaoticModules;
  };

  overlayPkgsAttrs = builtins.listToAttrs (
    map (name: {
      name = name;
      value = pkgs.${name};
    }) defaults.overlayPackageNames
  );

  customPkgsAttrs = builtins.listToAttrs (
    map (name: {
      name = name;
      value = customPkgs.${name};
    }) (builtins.attrNames customPkgs)
  );

in
{
  flake = {
    nixosConfigurations.nixos = mkConfig;

    packages.${system} = overlayPkgsAttrs // customPkgsAttrs;

    overlays.default = pkgs.lib.composeManyExtensions overlays;
    nixosModules.default = ./configuration.nix;
    homeManagerModules.default = ./home.nix;

    devShells.${system} = import ./dev/default.nix { inherit pkgs; };

    lib.mkSystem = constructors.mkSystem;
  };
}
