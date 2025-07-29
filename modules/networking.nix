# modules/networking.nix
{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces.wlp10s0.useDHCP = lib.mkForce true;
    firewall.enable = true;
  };
}

