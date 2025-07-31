# modules/boot.nix
{
  pkgs,
  lib,
  isLocal,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader =
      if isLocal then
        {
          systemd-boot = {
            enable = true;
            consoleMode = "max";
          };
          efi = {
            canTouchEfiVariables = true;
            # efiSysMountPoint = "/boot";
          };
        }
      else
        {
          grub = {
            enable = lib.mkForce false;
            devices = lib.mkForce [ ];
          };

          systemd-boot.enable = lib.mkForce false;

          efi = {
            canTouchEfiVariables = lib.mkForce false;
            efiSysMountPoint = "/boot";
          };
        };
  };

  # Disable bootloader install on Garnix (when not local build)
  system.build.bootStage1 = lib.mkIf (!isLocal) null;
  system.build.installBootLoader = lib.mkIf (!isLocal) (pkgs.writeShellScript "noop" "");
}
