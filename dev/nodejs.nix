# dev/nodejs.nix
{ pkgs }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs_24
    pkgs.nodePackages.npm
    pkgs.nodePackages.yarn
  ];

  shellHook = ''
    echo "Node.js 24 development shell activated."
  '';
}
