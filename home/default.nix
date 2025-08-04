# home/default.nix
{
  pkgs,
  lib,
  spicetify-nix,
  system,
  ...
}:

let
  commonArgs = { inherit pkgs; };
  spicetifyArgs = { inherit pkgs spicetify-nix system; };
  gnomeArgs = { inherit pkgs lib; };

  modulesWithCommonArgs = [
    "packages"
    "firefox"
    "gaming"
  ];

  mappedModules = builtins.map (name: import ./${name}.nix commonArgs) modulesWithCommonArgs;

in
{
  imports = mappedModules ++ [
    (import ./spicetify.nix spicetifyArgs)
    (import ./gnome.nix gnomeArgs)
    #./mount-google-drive.nix
  ];
}
