{ pkgs, ... }:

{
  # Tailscale VPN Service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client"; # Set to "both" or "server" if acting as an exit node/subnet router
  };

  # OpenSSH Daemon (Secure remote access)
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # Change to false once your SSH keys are set up
    };
  };

  # SSD Periodic TRIM Support
  services.fstrim.enable = true;

  # Mounting & Virtual Filesystem Daemons (Required for Dolphin / Yazi disk mounting & trash)
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}