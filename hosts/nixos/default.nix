{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Auto-copied by bootstrap script
    ../../modules                # Imports system modules from /modules
  ];

  # Allow unfree packages system-wide — shared with home-manager via
  # useGlobalPkgs, so it must live here rather than in home/default.nix
  nixpkgs.config.allowUnfree = true;

  # Primary User Account (Matches home-manager.users.healer in flake.nix)
  users.users.healer = {
    isNormalUser = true;
    description = "healer";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "docker" ];
    shell = pkgs.fish;
  };

  # Enable Fish shell system-wide so it gets added to /etc/shells
  programs.fish.enable = true;
}