# lib/pkgs.nix
{
  nixpkgs,
  system,
  overlays,
}:

import nixpkgs {
  inherit system overlays;
  config.allowUnfree = true;
}
