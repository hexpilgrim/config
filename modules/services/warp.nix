# modules/services/warp.nix
{ config, lib, pkgs, ... }:

let
  # Reference to module config for conditional activation
  cfg = config.services.cloudflare-warp-daemon;
in {
  # Toggle to enable Cloudflare WARP daemon
  options.services.cloudflare-warp-daemon.enable = lib.mkEnableOption "Enable Cloudflare WARP daemon";

  # Runtime configuration if WARP is enabled
  config = lib.mkIf cfg.enable {
    systemd.services.warp-svc = {
      description = "Cloudflare WARP Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
        Restart = "on-failure";
      };
    };

    # Suppress unwanted user-level tray icon
    systemd.user.services.warp-taskbar = {
      enable = false;
    };

    # Ensure warp binary is available in system environment
    environment.systemPackages = [ pkgs.cloudflare-warp ];
  };
}
