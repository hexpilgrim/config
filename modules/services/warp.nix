# modules/services/warp.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.cloudflare-warp-daemon;
in
{
  options.services.cloudflare-warp-daemon.enable = lib.mkEnableOption "Enable Cloudflare WARP daemon";

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

    # Disable user-level tray icon service (optional)
    systemd.user.services.warp-taskbar.enable = false;

    environment.systemPackages = [ pkgs.cloudflare-warp ];
  };
}
