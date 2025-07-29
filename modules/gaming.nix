# modules/gaming.nix
{ config, pkgs, ... }:

{
  # Configure Steam with runtime and network options
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;

    # Inject theme assets into Steam runtime to fix missing cursors/UI
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        adwaita-icon-theme  # Provide Adwaita cursor/theme inside Steam's runtime
      ];
    };
  };

  # Enable Feral's GameMode daemon for performance tweaks
  programs.gamemode.enable = true;

  # Configure Vulkan runtime and compatibility
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ amdvlk ];
    extraPackages32 = with pkgs.driversi686Linux; [ amdvlk ];
  };

  # Use AMD GPU driver via X server
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Fallback cursor for Steam runtime and Wayland edge cases
  xdg.icons.fallbackCursorThemes = [ "Adwaita" ];
}
