# modules/gaming.nix
{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;

    # Fix missing cursors/UI in Steam runtime with theme assets
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          adwaita-icon-theme
          adwsteamgtk
        ];
    };
  };

  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ amdvlk ];
    extraPackages32 = with pkgs.driversi686Linux; [ amdvlk ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  xdg.icons.fallbackCursorThemes = [ "Adwaita" ];
}
