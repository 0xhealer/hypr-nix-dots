{ pkgs, ... }:

{
  # Not using services.dunst's declarative config on purpose: wallust needs
  # to overwrite ~/.config/dunst/dunstrc at runtime whenever the wallpaper
  # changes, and home-manager-managed config files are read-only symlinks
  # into the Nix store. Dunst itself is launched via exec-once in
  # hyprland.nix; the seed dunstrc is written once by the activation
  # script in style/wallust.nix.
  home.packages = [ pkgs.dunst ];
}
