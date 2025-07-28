{ ... }:

let
  nix-flatpak = builtins.fetchTarball {
    url = "https://github.com/gmodena/nix-flatpak/archive/refs/heads/main.tar.gz";
    sha256 = "030qz6kf97vx4bk0vmgbq23kv7j9xry2mc1z96bw6cmdljf2prm0";
  };

  spicetify-nix = import (builtins.fetchTarball {
    url = "https://github.com/Gerg-L/spicetify-nix/archive/master.tar.gz";
    sha256 = "0hgl0lk8xld01cfr9nhhfbfa2qpjb70is194w7987bi4az4al3rv";
  }) { };

  spicePkgs = spicetify-nix.packages;
in
{

  _module.args.spicePkgs = spicePkgs;

  imports = builtins.concatLists [
    (import ./services)
    [
      ./hardware-configuration.nix
      ./flatpak.nix
      ./boot.nix
      ./networking.nix
      ./locale.nix
      ./users.nix
      ./filesystem.nix
      ./programs.nix
      ./packages.nix
      ./system.nix
      ./modules/spicetify.nix
      "${nix-flatpak}/modules/nixos.nix"
      spicetify-nix.nixosModules.spicetify
    ]
  ];
}
