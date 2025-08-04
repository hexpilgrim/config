# dev/nodejs.nix
{
  pkgs,
}:

# This Nix expression defines a development shell for Node.js
pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs_24
    pkgs.nodePackages.npm
    pkgs.nodePackages.yarn
  ];

  shellHook = ''
    echo "Node.js (24) dev shell activated."
  '';
}
