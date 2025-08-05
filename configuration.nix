# configuration.nix
let
  user = import ./user.nix;
in
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = import ./modules {
    inherit
      pkgs
      config
      user
      lib
      ;
  };

  nixpkgs.overlays = [
    (import ./overlays/spotify-patch.nix)
    (import ./overlays/catppuccin.nix)
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    xkb.variant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.printing.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  # Uncomment if you want Cloudflare Warp
  #services.cloudflare-warp-daemon.enable = true;

  system.stateVersion = "25.05";
}
