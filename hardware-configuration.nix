# hardware-configuration.nix
{ config, lib, pkgs, ... }:

let
  isLocal = builtins.getEnv "IS_LOCAL_BUILD" == "1";
in {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/01ef0406-8f77-4614-b5e0-2e4809127d7f";
    fsType = "ext4";
  };

  # Only mount /boot if local build
  fileSystems."/boot" = lib.mkIf isLocal {
    device = "/dev/disk/by-uuid/54EE-56AF";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Only mount /mnt/Backups if local build
  fileSystems."/mnt/Backups" = lib.mkIf isLocal {
    device = "LABEL=Backups";
    fsType = "auto";
    options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
  };

  # swap device only on local build
  swapDevices = lib.mkIf isLocal [
    { device = "/dev/disk/by-uuid/b779e0f7-6e56-4be1-a808-d779cc0b5b09"; }
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci" "nvme" "usb_storage" "sd_mod" "ahci" "usbhid"
  ];

  boot.kernelModules = [ "kvm-amd" ];

  boot.extraModulePackages = [ ];

  # Example for conditional networking DHCP usage
  networking.useDHCP = lib.mkDefault isLocal;

  # Enable only if local build
  nixpkgs.hostPlatform = lib.mkIf isLocal "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkIf isLocal (lib.mkDefault config.hardware.enableRedistributableFirmware);
}