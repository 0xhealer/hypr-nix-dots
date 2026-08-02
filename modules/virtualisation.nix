{ pkgs, ... }:

{
  # This machine is itself running as a VMware Workstation guest — enables
  # open-vm-tools so the display actually resizes to fill the VM window
  # (this is the fix for the small/boxed-in desktop), plus clipboard
  # sharing and other host integration.
  virtualisation.vmware.guest.enable = true;

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