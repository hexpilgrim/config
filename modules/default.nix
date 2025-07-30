# modules/default.nix
{ pkgs, user, lib, ... }:

let
  libArgs       = { inherit pkgs lib; };
  libOnlyArgs   = { inherit lib; };
  userArgs      = { inherit user; };
# fullUserArgs = { inherit pkgs user; };

in
[
  # Modules with no arguments (just `{ ... }`)
  ./locale.nix
  ./audio.nix
  ./maintenance.nix
  ./gaming.nix
  ./cursor.nix
  ./nix-ld.nix

  # Modules requiring minimal arguments
  (import ./packages.nix { inherit pkgs; })
  (import ./boot.nix libArgs)
  (import ./networking.nix libOnlyArgs)
  (import ./users.nix userArgs)

  # Module directories
  ./scripts
  ./services

  # Optional user module
# (import ./mount-google-drive.nix fullUserArgs)
]
