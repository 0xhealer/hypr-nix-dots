{ pkgs, ... }:

{
  # SDDM Display Manager with Wayland Enabled
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Hyprland session entry for SDDM + XDG portal
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # Enable Polkit Security Framework
  security.polkit.enable = true;

  # GNOME Polkit Graphical Authentication Agent (matches the GTK/Sweet
  # stack now that Plasma has been removed; started from hyprland.nix's
  # exec-once)
  environment.systemPackages = [ pkgs.polkit_gnome ];
}
