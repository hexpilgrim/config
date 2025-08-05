# modules/audio.nix
{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  systemd.user.services.mpd = {
    after = [
      "pipewire.service"
      "pipewire-pulse.service"
      "pipewire-pulse.socket"
    ];
    requires = [ "pipewire-pulse.socket" ];
  };
}
