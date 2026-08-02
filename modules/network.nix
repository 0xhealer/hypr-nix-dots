{ pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "9.9.9.9"];

    # System Firewall Configuration
    firewall = {
      enable = true;

      # Trust Tailscale mesh interface traffic
      trustedInterfaces = [ "tailscale0" ];
    };
  };
}