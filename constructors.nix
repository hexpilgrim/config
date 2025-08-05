# constructors.nix
{
  nixpkgs,
  pkgs,
  home-manager,
  spicetify-nix,
  ...
}:

let
  mkSystem =
    {
      system,
      user,
      flakeRoot,
      overlays,
      baseModules,
      extraModules,
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        baseModules
        ++ extraModules
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.${user.username} = import (flakeRoot + "/home.nix") {
              inherit
                pkgs
                user
                system
                spicetify-nix
                ;
              lib = pkgs.lib;
            };
          }
        ];
    };
in
{
  inherit mkSystem;
}
