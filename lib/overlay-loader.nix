# lib/overlay-loader.nix
{ system, defaults, flakeRoot, ... }:

let
  overlaysPath = "${flakeRoot}/overlays";

  argsMap = builtins.listToAttrs (
    map (name: {
      name = name;
      value = [ system ];
    }) defaults.overlayPackageNames
  );

  applyArgs =
    fn: args: if args == [] then fn else applyArgs (fn (builtins.head args)) (builtins.tail args);
in

builtins.attrValues (
  builtins.listToAttrs (
    map (name: {
      name = name;
      value = if name == "spotify-patch" then
        import (overlaysPath + "/${name}.nix")
      else if name == "catppuccin" then
        import (overlaysPath + "/${name}.nix")
      else
        applyArgs (import (overlaysPath + "/${name}.nix")) argsMap.${name};
    }) defaults.overlayPackageNames
  )
) ++ [
  (final: prev: {
    spotify = prev.spotify-patch;
  })
]
