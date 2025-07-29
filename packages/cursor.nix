# packages/cursor.nix
{ pkgs ? import <nixpkgs> {} }:

# Cursor is distributed as an AppImage (Type 2 wrapped here)
# This does not sandbox or unpack the app—just makes it executable
# AppImages rely on host libraries present in the runtime environment
pkgs.appimageTools.wrapType2 {
  pname = "cursor";
  version = "1.3.2";
  name = "cursor";  # Used for output directory

  # Fetch AppImage from official Cursor CDN
  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/production/7db9f9f3f612efbde8f318c1a7951aa0926fc1d0/linux/x64/Cursor-1.3.2-x86_64.AppImage";
    sha256 = "8at0Ofp/PwpaftfPrSM14ayBS4gk3URj637AY++N8h0=";
  };

  # Metadata for package introspection and indexing
  meta = with pkgs.lib; {
    description = "Cursor AI-powered code editor";
    homepage = "https://www.cursor.so/";
    license = licenses.unfree;  # Replace with exact license if known
    platforms = platforms.linux;
  };
}

