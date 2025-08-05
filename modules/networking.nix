# modules/networking.nix
{ lib, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces.wlp10s0.useDHCP = lib.mkForce true;
    firewall.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
}
