{ pkgs, ... }:

{
  imports = [
    # ./rofi.nix  -- disabled per request (switching away from rofi); flip back any time
    ./dunst.nix
  ];
}
