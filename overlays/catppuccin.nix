# overlays/catppuccin.nix
final: prev: {
  spicetify-catppuccin = prev.spicetify-catppuccin.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      echo "Installing patched theme with custom binary..."

      # Copy original theme assets
      mkdir -p $out/share/spicetify-catppuccin
      cp -r ${old.src}/* $out/share/spicetify-catppuccin/

      # Inject patched Spotify binary
      echo "Injecting spotify-patch binary..."
      mkdir -p $out/share/spotify
      ln -s ${final.spotify-patch}/share/spotify/spotify $out/share/spotify/spotify

      echo "Theme ready with patched Spotify binary"
    '';
  });
}
