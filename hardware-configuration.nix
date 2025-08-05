# hardware-configuration.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/01ef0406-8f77-4614-b5e0-2e4809127d7f";
    fsType = "ext4";
  };

  # Mount /boot
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/54EE-56AF";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Mount /mnt/Backups
  fileSystems."/mnt/Backups" = {
    device = "LABEL=Backups";
    fsType = "btrfs";
    options = [
      "nosuid"
      "nodev"
      "nofail"
      "x-gvfs-show"
    ];
  };

  # swap device
  swapDevices = [
    { device = "/dev/disk/by-uuid/b779e0f7-6e56-4be1-a808-d779cc0b5b09"; }
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "ahci"
    "usbhid"
  ];

  boot.kernelModules = [ "kvm-amd" ];

  boot.extraModulePackages = [ ];

  # Example for conditional networking DHCP usage
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = (lib.mkDefault config.hardware.enableRedistributableFirmware);
}
