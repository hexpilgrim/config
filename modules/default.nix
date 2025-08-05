# modules/default.nix
args@{ config, lib, ... }:

let
  entries = builtins.readDir ./.;
  attrNames = builtins.attrNames entries;

  # Filter regular files that end with .nix but exclude default.nix
  nixFiles = builtins.filter (
    name: entries.${name} == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) attrNames;

  importedModules = builtins.map (
    name:
    let
      path = ./. + "/${name}";
      argsNeeded = builtins.functionArgs (import path);
      argsToPass = builtins.intersectAttrs argsNeeded args;
    in
    import path argsToPass
  ) nixFiles;

in
importedModules
