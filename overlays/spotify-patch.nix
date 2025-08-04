# overlays/spotify-patch.nix
final: prev: {
  spotify-patch = prev.spotify.overrideAttrs (oldAttrs: {
    postPatch = ''
      echo "Locating Spotify binary..."
      binaryFile=$(find . -type f -name spotify | head -n1)

      if [ -z "$binaryFile" ]; then
        echo "Spotify binary not found during postPatch"
        find . -type f
        exit 1
      fi

      echo "Patching Spotify binary at $binaryFile"
      LC_CTYPE=C sed -i.bak 's/force-dark-mode/xxxxx-xxxx-xxxx/' "$binaryFile"
    '';

    installPhase = ''
      echo "Reorganizing install paths..."

      # Ensure Spotify lands at $out/share/spotify/spotify
      mkdir -p $out/share/spotify
      cp -r usr/share/spotify/* $out/share/spotify/

      binaryOut="$out/share/spotify/spotify"
      if [ -f "$binaryOut" ]; then
        echo "Marking binary executable: $binaryOut"
        chmod +x "$binaryOut"
      else
        echo "Expected binary not found at $binaryOut"
        ls -R "$out"
        exit 1
      fi
    '';
  });
}
