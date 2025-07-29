{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	boot = {
		initrd = {
			availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
		};
		
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];
	};

  fileSystems."/" = lib.mkForce { 
    device = "/dev/disk/by-uuid/01ef0406-8f77-4614-b5e0-2e4809127d7f";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkForce { 
    device = "/dev/disk/by-uuid/54EE-56AF";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  fileSystems."/mnt/Backups" = lib.mkForce {
    	device = "LABEL=Backups";
    	fsType = "auto";
    	options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/b779e0f7-6e56-4be1-a808-d779cc0b5b09"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
