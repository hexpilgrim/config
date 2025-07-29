# modules/boot.nix
{ config, pkgs, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
}

