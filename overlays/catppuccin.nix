# overlays/catppuccin.nix
final: prev: {
  spicetify-catppuccin = prev.spicetify-catppuccin.overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase + ''
      echo "Installing patched theme with custom binary..."

      mkdir -p $out/share/spicetify-catppuccin
      cp -r ${oldAttrs.src}/* $out/share/spicetify-catppuccin/

      echo "Injecting spotify-patch binary..."
      mkdir -p $out/share/spotify
      ln -s ${final.spotify-patch}/share/spotify/spotify $out/share/spotify/spotify

      echo "Theme ready with patched Spotify binary"
    '';
  });
}
