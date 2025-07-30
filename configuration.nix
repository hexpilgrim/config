# configuration.nix
let
  # Import user metadata to pass into modules
  user = import ./user.nix;
in
{ config, pkgs, lib, ... }:

{
  # Load modular system config and hardware details
  imports = import ./modules { inherit pkgs config user lib; };

  # Enable advanced Nix tooling
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Enable X11 and GNOME desktop environment
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    xkb.variant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.printing.enable = true;

  # Declarative activation of Cloudflare WARP daemon
#  services.cloudflare-warp-daemon.enable = true;

  # Set system version for compatibility
  system.stateVersion = "25.05";
}
