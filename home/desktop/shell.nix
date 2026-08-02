{ pkgs, ... }:

{
  imports = [
    ./rofi.nix   # re-enabled as the always-available launcher regardless of which bar wins
    ./dunst.nix
  ];
}
