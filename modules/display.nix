{ pkgs, ... }:

let
  # Catppuccin Mocha + Mauve — closest match to our own dark/purple palette
  # (colors.nix: background #0B0D0F, accent #9580FF). Reuses the same
  # wallpaper Waypaper defaults to, so the login screen and desktop match.
  sddmTheme = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font = "JetBrainsMono Nerd Font";
    fontSize = "10";
    background = "${../assets/wallpapers/6.png}";
    loginBackground = true;
  };
in
{
  # SDDM Display Manager with Wayland Enabled
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm; # Qt6 — required for this theme to load correctly
    theme = "catppuccin-mocha-mauve";
    extraPackages = [ sddmTheme ];
  };

  environment.systemPackages = [
    pkgs.polkit_gnome
    sddmTheme
  ];

  # Hyprland session entry for SDDM + XDG portal.
  #
  # withUWSM defaults to true in current nixpkgs, which generates a SECOND
  # session entry (hyprland-uwsm.desktop, "Hyprland (uwsm-managed)")
  # alongside the plain one — that's the two "Hyprland" entries in the SDDM
  # session picker. We're explicitly opting out: this repo already manages
  # session lifecycle through home-manager's own systemd integration
  # (services.dunst, services.hypridle), and the Hyprland wiki's own
  # warning for UWSM users is to *disable* that integration
  # (wayland.windowManager.hyprland.systemd.enable = false) — doing both at
  # once would just create a real conflict for a duplicate-entry cosmetic
  # fix. One clean "Hyprland" session it is.
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # Enable Polkit Security Framework
  security.polkit.enable = true;

  # GNOME Polkit Graphical Authentication Agent (matches the GTK stack now
  # that Plasma has been removed; started from hyprland.nix's autostart hook)
}
