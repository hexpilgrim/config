# modules/scripts/default.nix
{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./git-wrapper.nix
    ./unzip.nix
  ];
}
