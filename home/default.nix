{ pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./desktop/default.nix
    ./apps/default.nix
    ./style/default.nix
  ];

  home = {
    username = "healer";
    homeDirectory = "/home/healer";
    
    # State version (matches system stateVersion)
    stateVersion = "26.05";

    # Global environment variables for Wayland/Hyprland
    sessionVariables = {
      NIXOS_OZONE_WL = "1";               # Force Chromium/Electron apps to use Wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";            # Firefox/Zen Wayland rendering
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11,*";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}