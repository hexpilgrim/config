{ config, pkgs, ... }:

let
  nix-flatpak = builtins.fetchTarball {
    url = "https://github.com/gmodena/nix-flatpak/archive/refs/heads/main.tar.gz";
    sha256 = "030qz6kf97vx4bk0vmgbq23kv7j9xry2mc1z96bw6cmdljf2prm0";
  };

  spicetify-nix = import (builtins.fetchTarball {
    url = "https://github.com/Gerg-L/spicetify-nix/archive/master.tar.gz";
    sha256 = "0hgl0lk8xld01cfr9nhhfbfa2qpjb70is194w7987bi4az4al3rv";
  }) {};

  spicePkgs = spicetify-nix.packages;
in 
{
  imports = [ 
    ./hardware-configuration.nix 
    ./flatpak.nix
    "${nix-flatpak}/modules/nixos.nix"
    spicetify-nix.nixosModules.spicetify
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };

    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/mnt/Backups" = {
    device = "LABEL=Backups";
    fsType = "auto";
    options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
  };

  networking = {
    hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;  # Enable networking
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };
  
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      
      # Configure keymap in X11
      xkb = {
        layout = "gb";
        variant = "";
      };
      
      # Enable touchpad support (enabled default in most desktopManager).
      #libinput.enable = true;
    };
    
    # Enable CUPS to print documents.
    printing.enable = true;
    
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    gnome.gnome-keyring.enable = true;
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account.
  users.users.james = {
    isNormalUser = true;
    description = "James";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];

    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      newReleases
    ];

    enabledSnippets = with spicePkgs.snippets; [
      autoHideFriends
      modernScrollbar
      hideNowPlayingViewButton
      hideFriendActivityButton
      hideMiniPlayerButton
    ] ++ [
      ''
        [aria-label="All"],
        [aria-label="Music"],
        [aria-label="Podcasts"],
        [aria-label="Audiobooks"] {
          display: none !important;
        }
      ''
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.enableGnomeKeyring = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    gnupg
    pinentry-gnome3
    adw-gtk3
    megasync # no flatpak version
    github-desktop
  ];

  # Set system version for compatibility
  system.stateVersion = "25.05";
}
