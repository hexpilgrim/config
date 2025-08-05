# packages/cursor.nix
{
  pkgs ? import <nixpkgs> { },
}:

# Cursor editor distributed as an AppImage (wrapped as Type 2)
pkgs.appimageTools.wrapType2 {
  pname = "cursor";
  version = "1.3.2";
  name = "cursor";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/production/7db9f9f3f612efbde8f318c1a7951aa0926fc1d0/linux/x64/Cursor-1.3.2-x86_64.AppImage";
    sha256 = "8at0Ofp/PwpaftfPrSM14ayBS4gk3URj637AY++N8h0=";
  };

  meta = with pkgs.lib; {
    description = "Cursor AI-powered code editor";
    homepage = "https://www.cursor.so/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexpilgrim ];
  };
}
