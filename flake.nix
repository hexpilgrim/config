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

    # disko; declarative disk partitioning and formatting using nix
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };

    # flake-parts: simplify Nix Flakes with the module system
    flake-parts = { url = "github:hercules-ci/flake-parts"; };

    # flake-utils: pure Nix flake utility functions
    flake-utils = { url = "github:numtide/flake-utils"; };

    # lanzaboote: Secure Boot for NixOS
    #lanzaboote = { url = "github:nix-community/lanzaboote"; };

    # nix-index: quickly locate nix packages with specific files
    nix-index = { url = "github:nix-community/nix-index"; inputs.nixpkgs.follows = "nixpkgs"; };

    # nixos-hardware: a collection of NixOS modules covering hardware quirks
    nixos-hardware = { url = "github:NixOS/nixos-hardware"; };

    # catppiccin: a soothing pastel theme for Nix
    catppuccin = { url = "github:catppuccin/nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, ... }@inputs: import ./outputs.nix inputs self;
}
