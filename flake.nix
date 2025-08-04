{
  description = "hexpilgrim: a nixos configuration flake";

  inputs = {
    # Nixpkgs: the standard package set and system configuration modules for Nix and NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Home Manager: declarative user configuration framework for managing dotfiles and user packages
    home-manager = { url = "github:nix-community/home-manager/release-25.05"; inputs.nixpkgs.follows = "nixpkgs"; };

    # NUR (Nix User Repository): a community-curated collection of additional packages
    nur = { url = "github:nix-community/NUR"; inputs.nixpkgs.follows = "nixpkgs"; };

    # Chaotic-Nix: a repository of packages for NixOS that are not available in the official nixpkgs
    chaotic = { url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; inputs.nixpkgs.follows = "nixpkgs"; };

    # Spicetify-Nix: a Nix flake for managing Spicetify, a tool for customizing Spotify clients
    spicetify-nix = { url = "github:Gerg-L/spicetify-nix"; inputs.nixpkgs.follows = "nixpkgs"; };

    # umu-launcher: a Nix flake for managing the umu launcher, a tool for launching applications
    umu = { url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix"; inputs.nixpkgs.follows = "nixpkgs"; };
 
    # nix-gaming: a Nix flake for managing gaming-related packages and configurations
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    import ./builders.nix inputs self;
}
