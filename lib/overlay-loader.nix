# lib/overlay-loader.nix
{
  system,
  defaults,
  ...
}:

let
  # Path to all overlay definitions; each must be named to match entries in overlayPackageNames
  overlaysPath = ../overlays;

  # Build argument map for curried overlay functions; each receives system as its sole parameter
  argsMap = builtins.listToAttrs (
    map (name: {
      name = name;
      value = [ system ];
    }) defaults.overlayPackageNames
  );

  # Recursively apply curried arguments to an overlay function
  applyArgs =
    fn: args: if args == [ ] then fn else applyArgs (fn (builtins.head args)) (builtins.tail args);
in

# Load and apply all overlays listed in overlayPackageNames
# Result is an attrSet of overlays: each is a function (self: super: { ... })
builtins.attrValues (
  builtins.listToAttrs (
    map (name: {
      name = name;
      value = applyArgs (import (overlaysPath + "/${name}.nix")) argsMap.${name};
    }) defaults.overlayPackageNames
  )
)
