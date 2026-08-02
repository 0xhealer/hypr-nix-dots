{ pkgs, ... }:

{
  # Docker Daemon Configuration
  virtualisation.docker = {
    enable = true;
    
    # Automatically clean up unused containers, networks, and images
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}