# modules/boot.nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
