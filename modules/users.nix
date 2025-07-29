# modules/users.nix
{ config, pkgs, user, ... }:

{
  users.users.${user.username} = {
    isNormalUser = true;
    description = user.username;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "users" ];
  };
}
