# modules/default.nix
{ pkgs, config, user, lib, ... }:

let
  commonArgs = { inherit pkgs config; };
  userArgs   = { inherit pkgs config user; };

  # List of modules accepting only pkgs + config
  modulesWithCommonArgs = [
    "boot"
    "locale"
    "audio"
    "maintenance"
    "gaming"
    "cursor"
    "nix-ld"
  ];

  # Import each module with commonArgs
  modules = builtins.map
    (name: import ./${name}.nix commonArgs)
    modulesWithCommonArgs;

in
   # Concatenate all modules into final config list
  modules ++ [
    (import ./packages.nix { inherit pkgs; })
    (import ./networking.nix { inherit pkgs config lib; } )
    (import ./users.nix userArgs)
    ./scripts
    ./services
    #(import ./mount-google-drive.nix userArgs)
  ]
